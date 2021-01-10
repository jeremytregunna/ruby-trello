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

    def self.schema(&block)
      @schema ||= Schema.new
      return @schema unless block_given?

      @schema.instance_eval(&block)

      register_attrs

      @schema
    end

    def self.register_attrs
      schema.attrs.values.each do |attribute|
        attribute.register(self)
      end
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

    attr_writer :client

    def initialize(fields = {})
      initialize_fields(fields)
    end

    def save
      return update! if id

      payload = {}

      schema.attrs.each do |_, attribute|
        payload = attribute.build_payload_for_create(attributes, payload)
      end

      post(collection_path, payload)
    end

    def update!
      fail "Cannot save new instance." unless id

      @previously_changed = changes

      payload = {}
      changed_attrs = attributes.select {|name, _| changed.include?(name.to_s)}

      schema.attrs.each do |_, attribute|
        payload = attribute.build_payload_for_update(changed_attrs, payload)
      end

      from_response client.put(element_path, payload)

      @changed_attributes.clear if @changed_attributes.respond_to?(:clear)
      changes_applied if respond_to?(:changes_applied)

      self
    end

    def update_fields(fields)
      attrs = {}

      schema.attrs.each do |_, attribute|
        attrs = attribute.build_pending_update_attributes(fields, attrs)
      end

      attrs.each do |name, value|
        send("#{name}=", value)
      end

      self
    end

    def collection_path
      "/#{collection_name}"
    end

    def element_path
      "/#{collection_name}/#{id}"
    end

    def collection_name
      @collection_path ||= ActiveSupport::Inflector.pluralize(element_name)
    end

    def element_name
      @element_name ||= model_name.element
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

    def schema
      self.class.schema
    end

    def attributes
      @__attributes ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    private

    def attributes=(attrs)
      @__attributes = attrs
    end

    def initialize_fields(fields)
      schema.attrs.each do |_, attribute|
        self.attributes = attribute.build_attributes(fields, attributes)
      end

      self
    end

    def post(path, body)
      from_response client.post(path, body)
    end

    def put(path, body)
      from_response client.put(path, body)
    end
  end
end
