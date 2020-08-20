
module Trello
  class BasicDataAlpha < BasicData
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

      from_response_v2 client.put(element_path, payload)

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

    private

    def initialize_fields(fields)
      schema.attrs.each do |_, attribute|
        self.attributes = attribute.build_attributes(fields, attributes)
      end

      self
    end

    def post(path, body)
      from_response_v2 client.post(path, body)
    end
  end
end