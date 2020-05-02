require 'active_support/inflector'

module Trello
  class BasicData
    include ActiveModel::Validations
    include ActiveModel::Dirty
    include ActiveModel::Serializers::JSON

    include Trello::JsonUtils

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
        from_response(response).tap do |basic_data|
          yield basic_data if block_given?
        end
      end

      def parse_many(response)
        from_response(response).map do |data|
          data.tap do |d|
            yield d if block_given?
          end
        end
      end
    end

    def self.register_attributes(*names_and_options)
      has_opts = names_and_options.last.kind_of?(Hash)
      readonly_attributes = has_opts ? names_and_options.pop[:readonly] : []
      attributes = names_and_options

      RegisterAttributes.execute(self, attributes, readonly_attributes)
    end

    def self.one(name, opts = {})
      AssociationBuilder::HasOne.build(self, name, opts)
    end

    def self.many(name, opts = {})
      AssociationBuilder::HasMany.build(self, name, opts)
    end

    def self.client
      Trello.client
    end

    register_attributes :id, readonly: [ :id ]

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
      self.class == other.class && id == other.id
    end

    # Alias hash equality to equality
    alias eql? ==

    # Delegate hash key computation to class and id pair
    def hash
      [self.class, id].hash
    end

    def client
      @client ||= self.class.client
    end
  end
end
