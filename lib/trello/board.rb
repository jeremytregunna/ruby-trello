module Trello

  class Board < BasicData
    attr_reader :id, :name, :description, :url, :organization_id

    class << self

      def find(id)
        super(:boards, id)
      end

      def create(attributes)
        Client.post("/boards/", attributes).json_into Board
      end
    end

    def save!
      fail "Cannot save new instance." unless self.id

      Client.put("/boards/#{self.id}/", {
        :name            => @name,
        :description     => @description,
        :closed          => @closed,
        :url             => @url,
        :organisation_id => @organisation_id
      }).json_into(self)
    end

    def update_fields(fields)
      @id              = fields['id']              if fields['id']
      @name            = fields['name']            if fields['name']
      @description     = fields['desc']            if fields['desc']
      @closed          = fields['closed']          if fields.has_key?('closed')
      @url             = fields['url']             if fields['url']
      @organization_id = fields['idOrganization']  if fields['idOrganization']

      self
    end

    def closed?
      @closed
    end

    # Return a timeline of actions related to this board.
    def actions
      return @actions if @actions
      @actions = Client.get("/boards/#{id}/actions").json_into(Action)
    end

    # Return all the cards on this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def cards(options = { :filter => :open })
      return @cards if @cards
      @cards = Client.get("/boards/#{id}/cards").json_into(Card)
    end

    # Returns all the lists on this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def lists(options = { :filter => :open })
      return @lists if @lists
      @lists = Client.get("/boards/#{id}/lists", options).json_into(List)
    end

    # Returns an array of members who are associated with this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :normal, :owners, :all ] # default :all
    def members(options = { :filter => :all })
      return @members if @members
      @members = Client.get("/boards/#{id}/members", options).json_into(Member)
    end

    # Returns a reference to the organization this board belongs to.
    def organization
      return @organization if @organization
      @organization = Organization.find(organization_id)
    end
  end
end
