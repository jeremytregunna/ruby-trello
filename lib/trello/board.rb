module Trello
  # A board is a container which holds lists. This is where everything lives.
  class Board < BasicData
    attr_reader :id, :name, :description, :closed, :url, :organization_id

    class << self
      # Locate a board given a specific id.
      def find(id)
        super(:boards, id)
      end
    end

    # Update the fields of a board.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a board.
    def update_fields(fields)
      @id              = fields['id']
      @name            = fields['name']
      @description     = fields['desc']
      @closed          = fields['closed']
      @url             = fields['url']
      @organization_id = fields['idOrganization']
    end

    # Check if the board is active.
    def closed?
      closed
    end

    # Return a timeline of actions related to this board.
    def actions
      return @actions if @actions
      @actions = Client.get("/boards/#{id}/actions").json_into(Action)
    end

    # Return all the cards on this board.
    def cards
      return @cards if @cards
      @cards = Client.get("/boards/#{id}/cards/all").json_into(Card)
    end

    # Returns all the lists on this board.
    def lists
      return @lists if @lists
      @lists = Client.get("/boards/#{id}/lists/all").json_into(List)
    end

    # Returns an array of members who are associated with this board.
    def members
      return @members if @members
      @members = Client.get("/boards/#{id}/members/all").json_into(Member)
    end

    # Returns a reference to the organization this board belongs to.
    def organization
      return @organization if @organization
      @organization = Organization.find(organization_id)
    end
  end
end
