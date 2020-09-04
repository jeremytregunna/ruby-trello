module Trello
  # A Checklist holds items which are like a "task" list. Checklists are linked to a card.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] position
  #   @return [Object]
  # @!attribute [r] check_items
  #   @return [Object]
  # @!attribute [r] board_id
  #   @return [String] A 24-character hex string
  class Checklist < BasicDataAlpha
    schema do
      attribute :id, readonly: true, primary_key: true

      # Readonly
      attribute :check_items, readonly: true, remote_key: 'checkItems'
      attribute :board_id, readonly: true, remote_key: 'idBoard'

      # Writable
      attribute :name
      attribute :position, remote_key: 'pos'

      # Writable but for update only
      attribute :card_id, create_only: true, remote_key: 'idCard'
      attribute :source_checklist_id, create_only: true, remote_key: 'idChecklistSource'
    end

    validates_presence_of :id
    validates_length_of :name, in: 1..16384

    # Check if the checklist is currently active.
    def closed?
      closed
    end

    # Return a list of items on the checklist.
    def items
      check_items.map do |item_fields|
        Item.new(item_fields)
      end
    end

    # Return a reference to the board the checklist is on.
    one :board, path: :checklists, using: :board_id

    # Return a reference to the card the checklist is on.
    one :card, path: :checklists, using: :card_id

    # Add an item to the checklist
    def add_item(name, checked = false, position = 'bottom')
      client.post("/checklists/#{id}/checkItems", {name: name, checked: checked, pos: position})
    end

    # Update a checklist item's state, e.g.: "complete" or "incomplete"
    def update_item_state(item_id, state)
      state = ( state ? 'complete' : 'incomplete' ) unless state.is_a?(String)
      client.put(
          "/cards/#{card_id}/checkItem/#{item_id}",
          state: state
      )
    end

    # Delete a checklist item
    def delete_checklist_item(item_id)
      client.delete("/checklists/#{id}/checkItems/#{item_id}")
    end

    # Delete a checklist
    def delete
      client.delete("/checklists/#{id}")
    end

    # Copy a checklist (i.e., same attributes, items, etc.)
    def copy
      checklist_copy = self.class.create(name: self.name, board_id: self.board_id, card_id: self.card_id)
      copy_items_to(checklist_copy)
      return checklist_copy
    end

    private
    def copy_items_to(another_checklist)
      items.each do |item|
        another_checklist.add_item(item.name, item.complete?)
      end
    end
  end
end
