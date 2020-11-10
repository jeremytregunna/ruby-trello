module Trello
  # A custom field item contains the value for a custom field on a particular card.
  #
  class CustomFieldItem < BasicData

    schema do
      attribute :id, readonly: true, primary_key: true
      attribute :model_id, readonly: true, remote_key: 'idModel'
      attribute :model_type, readonly: true, remote_key: 'modelType'
      attribute :custom_field_id, readonly: true, remote_key: 'idCustomField'
      attribute :option_id, readonly: true, remote_key: 'idValue'

      attribute :value
    end

    validates_presence_of :id, :model_id, :custom_field_id

    # References the card with this custom field value
    one :card, path: :cards, using: :model_id

    # References the parent custom field that this item is an instance of
    one :custom_field, path: 'customFields', using: :custom_field_id

    def save
      return update! if id

      payload = {}

      schema.attrs.each do |_, attribute|
        payload = attribute.build_payload_for_create(attributes, payload)
      end

      put(element_path, payload)
    end

    def collection_path
      "/cards/#{model_id}/#{collection_name}"
    end

    def element_path
      "/cards/#{model_id}/customField/#{custom_field_id}/item"
    end

    # You can't "delete" a custom field item, you can only clear the value
    def remove
      params = { value: {} }
      client.put(element_path, params)
    end

    # Type is saved at the CustomField level
    # Can equally be derived from :value, with a little parsing work: {"number": 42}
    def type
      custom_field.type
    end

    # Need to make another call to get the actual value if the custom field type == 'list'
    def option_value
      if option_id
        option_endpoint = "/customFields/#{custom_field_id}/options/#{option_id}"
        option = CustomFieldOption.from_response client.get(option_endpoint)
        option.value
      end
    end
  end
end
