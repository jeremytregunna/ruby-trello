module Trello
  # Represents the state of an item.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] state
  #   @return [Object]
  # @!attribute [r] item_id
  #   @return [String]
  class CheckItemState < BasicDataAlpha
    schema do
      #Readonly
      attribute :id, remote_key: 'idCheckItem', readonly: true, primary_key: true
      attribute :state
    end

    validates_presence_of :id

    # Return the item this state belongs to.
    def item
      Item.find(id)
    end
  end
end
