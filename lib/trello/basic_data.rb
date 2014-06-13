require 'trello/core_ext/array'
require 'trello/core_ext/hash'
require 'trello/core_ext/string'
require 'active_support/inflector'

module Trello
  class BasicData
    include ActiveModel::Validations
    include ActiveModel::Dirty
    include ActiveModel::Serializers::JSON

    class << self
      def path_name
        name.split("::").last.underscore
      end

      def find(id, params = {})
        client.find(path_name, id, params)
      end

      def create(options)
        client.create(path_name, options)
      end

      def save(options)
        new(options).tap do |basic_data|
          yield basic_data if block_given?
        end.save
      end

      def parse(response)
        response.json_into(self).tap do |basic_data|
          yield basic_data if block_given?
        end
      end

      def parse_many(response)
        response.json_into(self).map do |data|
          data.tap do |d|
            yield d if block_given?
          end
        end
      end
    end

    def self.register_attributes(*names)
      options = { :readonly => [] }
      options.merge!(names.pop) if names.last.kind_of? Hash

      # Defines the attribute getter and setters.
      class_eval do
        define_method :attributes do
          @attributes ||= names.reduce({}) { |hash, k| hash.merge(k.to_sym => nil) }
        end

        names.each do |key|
          define_method(:"#{key}") { @attributes[key] }

          unless options[:readonly].include?(key.to_sym)
            define_method :"#{key}=" do |val|
              send(:"#{key}_will_change!") unless val == @attributes[key]
              @attributes[key] = val
            end
          end
        end

        define_attribute_methods names
      end
    end

    def self.one(name, opts = {})
      class_eval do
        define_method(:"#{name}") do |*args|
          options = opts.dup
          klass   = options.delete(:via) || Trello.const_get(name.to_s.camelize)
          ident   = options.delete(:using) || :id
          path    = options.delete(:path)

          if path
            client.find(path, self.send(ident))
          else
            klass.find(self.send(ident))
          end
        end
      end
    end

    def self.many(name, opts = {})
      class_eval do
        define_method(:"#{name}") do |*args|
          options   = opts.dup
          resource  = options.delete(:in)  || self.class.to_s.split("::").last.downcase.pluralize
          klass     = options.delete(:via) || Trello.const_get(name.to_s.singularize.camelize)
          params    = options.merge(args[0] || {})
          resources = client.find_many(klass, "/#{resource}/#{id}/#{name}", params)
          MultiAssociation.new(self, resources).proxy
        end
      end
    end

    def self.client
      Trello.client
    end

    register_attributes :id, :readonly => [ :id ]

    attr_writer :client

    def initialize(fields = {})
      update_fields(fields)
    end

    def update_fields(fields)
      raise NotImplementedError, "#{self.class} does not implement update_fields."
    end

    # Refresh the contents of our object.
    def refresh!
      self.class.find(id)
    end

    # Two objects are equal if their _id_ methods are equal.
    def ==(other)
      id == other.id
    end

    def client
      @client ||= self.class.client
    end
  end
end
