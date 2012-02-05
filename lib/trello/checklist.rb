module Trello
  # A Checklist holds items which are like a "todo" list. Checklists are linked to a card.
  class Checklist < BasicData
    attr_reader :id, :name, :description, :closed, :url, :check_items, :board_id, :list_id, :member_ids

    class << self
      # Locate a specific checklist by its id.
      def find(id)
        super(:checklists, id)
      end

      def create(options)
        new('name'       => options[:name],
            'idBoard'    => options[:board_id]).save!
      end
    end

    # Update the fields of a checklist.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a checklist.
    def update_fields(fields)
      @id          = fields['id']
      @name        = fields['name']
      @description = fields['desc']
      @closed      = fields['closed']
      @url         = fields['url']
      @check_items = fields['checkItems']
      @board_id    = fields['idBoard']
      @member_ids  = fields['idMembers']
      self
    end

    # Check if the checklist is currently active.
    def closed?
      closed
    end

    # Save a record.
    def save!
      return update! if id

      Client.post("/checklists", {
        :name => @name,
        :idBoard => @board_id
      })
    end

    def update!
    end

    # Return a list of items on the checklist.
    def items
     return @items if @items

      @items = check_items.map do |item_fields|
        Item.new(item_fields)
      end
    end

    # Return a reference to the board the checklist is on.
    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    # Return a reference to the list the checklist is on.
    def list
      return @list if @list
      @list = List.find(list_id)
    end

    # Return a list of members active in this checklist.
    def members
      return @members if @members

      @members = member_ids.map do |member_id|
        Member.find(member_id)
      end
    end

    # Add an item to the checklist
    def add_item(name)
      Client.post("/checklists/#{id}/checkItems", { :name => name })
    end
  end
end
