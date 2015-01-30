module Trello
  # A Checklist holds items which are like a "task" list. Checklists are linked to a card.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [r] description
  #   @return [String]
  # @!attribute [r] closed
  #   @return [Boolean]
  # @!attribute [rw] position
  #   @return [Object]
  # @!attribute [r] url
  #   @return [String]
  # @!attribute [r] check_items
  #   @return [Object]
  # @!attribute [r] board_id
  #   @return [String] A 24-character hex string
  # @!attribute [r] list_id
  #   @return [String] A 24-character hex string
  # @!attribute [r] member_ids
  #   @return [Array<String>] An array of 24-character hex strings
  class Checklist < BasicData
    register_attributes :id, :name, :description, :closed, :position, :url, :check_items, :board_id, :list_id, :member_ids,
                        readonly: [:id, :description, :closed, :url, :check_items, :board_id, :list_id, :member_ids]
    validates_presence_of :id, :board_id, :list_id
    validates_length_of :name, in: 1..16384

    class << self
      # Locate a specific checklist by its id.
      def find(id, params = {})
        client.find(:checklist, id, params)
      end

      def create(options)
        client.create(:checklist,
                      'name' => options[:name],
                      'idBoard' => options[:board_id])
      end
    end

    # Update the fields of a checklist.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a checklist.
    def update_fields(fields)
      attributes[:id] = fields['id']
      attributes[:name] = fields['name']
      attributes[:description] = fields['desc']
      attributes[:closed] = fields['closed']
      attributes[:url] = fields['url']
      attributes[:check_items] = fields['checkItems']
      attributes[:position] = fields['pos']
      attributes[:board_id] = fields['idBoard']
      attributes[:list_id] = fields['idList']
      attributes[:member_ids] = fields['idMembers']
      self
    end

    # Check if the checklist is currently active.
    def closed?
      closed
    end

    # Save a record.
    def save
      return update! if id

      client.post("/checklists", {
          name: name,
          idBoard: board_id
      }).json_into(self)
    end

    def update!
      client.put("/checklists/#{id}", {name: name, pos: position}).json_into(self)
    end

    # Return a list of items on the checklist.
    def items
      check_items.map do |item_fields|
        Item.new(item_fields)
      end
    end

    # Return a reference to the board the checklist is on.
    one :board, path: :checklists, using: :board_id

    # Return a reference to the list the checklist is on.
    one :list, path: :lists, using: :list_id

    # Return a list of members active in this checklist.
    def members
      members = member_ids.map do |member_id|
        Member.find(member_id)
      end
      MultiAssociation.new(self, members).proxy
    end

    # Add an item to the checklist
    def add_item(name, checked=false, position='bottom')
      client.post("/checklists/#{id}/checkItems", {name: name, checked: checked, pos: position})
    end

    # Delete a checklist item
    def delete_checklist_item(item_id)
      client.delete("/checklists/#{id}/checkItems/#{item_id}")
    end

    # Delete a checklist
    def delete
      client.delete("/checklists/#{id}")
    end
  end
end
