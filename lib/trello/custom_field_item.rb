module Trello
  class CustomFieldItem < BasicData
    register_attributes :id, :model_id, :model_type, :custom_field_id, :value
    validates_presence_of :id, :model_id, :custom_field_id

    # Update the fields of a custom field item.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      attributes[:id]               = fields['id'] || attributes[:id]
      attributes[:model_id]         = fields['idModel'] || attributes[:model_id]
      attributes[:custom_field_id]  = fields['idCustomField'] || attributes[:custom_field_id]
      attributes[:model_type]       = fields['modelType'] || attributes[:model_type]
      attributes[:value]            = fields['value'] if fields.has_key?('value')
      self
    end

    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/card/#{model_id}/customField/#{custom_field_id}/item", payload)
    end

    # References the card with this custom field value
    one :card, path: :cards, using: :model_id

    # You can't "delete" a custom field item, you can only clear the value
    def remove
      params = { value: {} }
      client.put("/card/#{model_id}/customField/#{custom_field_id}/item", params)
    end
  end
end
