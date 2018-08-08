module Trello
  # A custom field option contains the individual items in a custom field dropdown menu.
  #
  class CustomFieldOption < BasicData
    register_attributes :id, :value, :pos, :color,
                        readonly: [:id]
    validates_presence_of :id, :value

    # Update the fields of a custom field option.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      attributes[:id]               = fields['_id'] || fields[:id] || attributes[:id]
      attributes[:color]            = fields['color'] || fields[:color] || attributes[:color]
      attributes[:pos]              = fields['pos'] || fields[:pos] || attributes[:pos]
      # value format: { "text": "hello world" }
      attributes[:value]            = fields['value'] || fields[:value] || attributes[:value]
      self
    end
  end
end
