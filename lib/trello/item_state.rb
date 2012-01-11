module Trello
  # Represents the state of an item.
  class ItemState < BasicData
    attr_reader :id, :state, :item_id

    # Create a new item state.
    #
    # Optionally supply a hash of string keyed data retrieved from the Trello API
    # representing an item state.
    def initialize(fields = {})
      @id      = fields['id']
      @state   = fields['state']
      @item_id = fields['idItem']
    end

    # Return the item this state belongs to.
    def item
      Item.find(@item_id)
    end
  end
end