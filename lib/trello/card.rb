module Trello
  # A Card is a container that can house checklists and comments; it resides inside a List.
  class Card < BasicData
    register_attributes :id, :name, :description, :closed, :url, :board_id, :member_ids, :list_id
    validates_presence_of :id, :name, :list_id

    class << self
      # Find a specific card by its id.
      def find(id)
        super(:cards, id)
      end

      # Create a new card and save it on Trello.
      def create(options)
        new('name'   => options[:name],
            'idList' => options[:list_id],
            'desc'   => options[:description]).save
      end
    end

    # Update the fields of a card.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a card.
    def update_fields(fields)
      attributes[:id]          = fields['id']
      attributes[:name]        = fields['name']
      attributes[:description] = fields['desc']
      attributes[:closed]      = fields['closed']
      attributes[:url]         = fields['url']
      attributes[:board_id]    = fields['idBoard']
      attributes[:member_ids]  = fields['idMembers']
      attributes[:list_id]     = fields['idList']
      self
    end

    # Returns a list of the actions associated with this card.
    def actions
      Client.get("/cards/#{id}/actions").json_into(Action)
    end

    # Returns a reference to the board this card is part of.
    def board
      Board.find(board_id)
    end

    # Returns a list of checklists associated with the card.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :all ] # default :all
    def checklists(options = { :filter => :all })
      Client.get("/cards/#{id}/checklists", options).json_into(Checklist)
    end

    # Returns a reference to the list this card is currently in.
    def list
      List.find(list_id)
    end

    # Returns a list of members who are assigned to this card.
    def members
      member_ids.map do |member_id|
        Client.get("/members/#{member_id}").json_into(Member)
      end
    end

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      Client.post("/cards", {
        :name   => name,
        :desc   => description,
        :idList => list_id
      }).json_into(self)
    end

    # Update an existing record.
    # Warning, this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    def update!
      @previously_changed = changes
      @changed_attributes.clear

      Client.put("/cards/#{@id}", {
        :name      => name,
        :desc      => description,
        :closed    => closed,
        :idList    => list_id,
        :idBoard   => board_id,
        :idMembers => member_ids
      }).json_into(self)
    end

    # Is the record valid?
    def valid?
      name && list_id
    end

    # Add a comment with the supplied text.
    def add_comment(text)
      Client.post("/cards/#{id}/actions/comments", :text => text)
    end

    # Add a checklist to this card
    def add_checklist(checklist)
      Client.post("/cards/#{id}/checklists", {
        :value => checklist.id
      })
    end

    # Add a label
    def add_label(colour)
      return logger.warn "The label colour '#{colour}' does not exist." unless %w{green yellow orange red purple blue}.include? colour
      Client.post("/cards/#{id}/labels", { :value => colour })
    end

    # Remove a label
    def remove_label(colour)
      return logger.warn "The label colour '#{colour}' does not exist." unless %w{green yellow orange red purple blue}.include? colour
      Client.delete("/cards/#{id}/labels/#{colour}")
    end
  end
end
