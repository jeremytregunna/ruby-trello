module Trello
  # A custom field item contains the value for a custom field on a particular card.
  #
  class CustomFieldItem < BasicData
    register_attributes :id, :model_id, :model_type, :custom_field_id, :value, :option_id,
                        readonly: [ :id, :custom_field_id, :model_id, :model_type, :option_id ]
    validates_presence_of :id, :model_id, :custom_field_id

    # References the card with this custom field value
    one :card, path: :cards, using: :model_id

    # References the parent custom field that this item is an instance of
    one :custom_field, path: 'customFields', using: :custom_field_id

    # Update the fields of a custom field item.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      attributes[:id]               = fields['id'] || fields[:id] || attributes[:id]
      attributes[:model_id]         = fields['idModel'] || fields[:model_id] || attributes[:model_id]
      attributes[:custom_field_id]  = fields['idCustomField'] || fields[:custom_field_id] || attributes[:custom_field_id]
      attributes[:model_type]       = fields['modelType'] || fields[:model_type] || attributes[:model_type]
      # Dropdown custom field items do not have a value, they have an ID that maps to
      # a different endpoint to get the value
      attributes[:option_id]       = fields['idValue'] if fields.has_key?('idValue')
      # value format: { "text": "hello world" }
      attributes[:value]            = fields['value'] if fields.has_key?('value')
      self
    end

    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [key.to_sym, values[1]] }]
      @changed_attributes.try(:clear)
      changes_applied if respond_to?(:changes_applied)

      client.put("/card/#{model_id}/customField/#{custom_field_id}/item", payload)
    end

    # Saves a record.
    #
    # @raise [Trello::Error] if the card could not be saved
    #
    # @return [String] The JSON representation of the saved custom field item returned by
    # the Trello API.
    def save
      # If we have an id, just update our fields.
      return update! if id

      from_response client.post("/card/#{model_id}/customField/#{custom_field_id}/item", {
        value: value
      })
    end

    # You can't "delete" a custom field item, you can only clear the value
    def remove
      params = { value: {} }
      client.put("/card/#{model_id}/customField/#{custom_field_id}/item", params)
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
