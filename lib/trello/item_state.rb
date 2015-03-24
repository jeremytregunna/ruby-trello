module Trello
  # Represents the state of an item.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] state
  #   @return [Object]
  # @!attribute [r] item_id
  #   @return [String]
  class CheckItemState < BasicData
    register_attributes :id, :state, :item_id, readonly: [ :id, :state, :item_id ]
    validates_presence_of :id, :item_id

    # Update the fields of an item state.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      attributes[:id]      = fields['id']
      attributes[:state]   = fields['state']
      attributes[:item_id] = fields['idCheckItem']
      self
    end

    # Return the item this state belongs to.
    def item
      Item.find(item_id)
    end
  end
end
