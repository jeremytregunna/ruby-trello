module Trello
  # Represents the state of an item.
  class ItemState < BasicData
    attr_reader :id, :state, :item_id

    # Update the fields of an item state.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item state.
    def update_fields(fields)
      @id      = fields['id']
      @state   = fields['state']
      @item_id = fields['idItem']
      self
    end

    # Return the item this state belongs to.
    def item
      Item.find(@item_id)
    end
  end
end