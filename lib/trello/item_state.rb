module Trello
  # Represents the state of an item.
  class ItemState < BasicData
    register_attributes :id, :state, :item_id, :readonly => [ :id, :state, :item_id ]
    validates_presence_of :id, :item_id

    # Update the fields of an item state.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      attributes[:id]      = fields['id']
      attributes[:state]   = fields['state']
      attributes[:item_id] = fields['idItem']
      self
    end

    # Return the item this state belongs to.
    def item
      Item.find(item_id)
    end
  end
end