require 'trello/string'

module Trello
  class BasicData
    include ActiveModel::Validations
    include ActiveModel::Dirty
    include ActiveModel::Serializers::JSON

    class << self
      def find(path, id)
        Client.get("/#{path}/#{id}").json_into(self)
      end
    end

    def self.register_attributes(*names)
      options = { :readonly => [] }
      options.merge!(names.pop) if names.last.kind_of? Hash

      # Defines the attribute getter and setters.
      class_eval do
        define_method :attributes do
          @attributes ||= names.inject({}) { |hash,k| hash.merge(k.to_sym => nil) }
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
          klass.find(self.send(ident))
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
          resources = Client.get("/#{resource}/#{id}/#{name}", options).json_into(klass)
          MultiAssociation.new(self, resources).proxy
        end
      end
    end

    register_attributes :id, :readonly => [ :id ]

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
  end
end
