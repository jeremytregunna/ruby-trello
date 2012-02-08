module Trello

  class Board < BasicData
    register_attributes :id, :name, :description, :url, :organization_id
    validates_presence_of :id, :name

    class << self
      # Finds a board.
      def find(id)
        super(:boards, id)
      end

      def create(fields)
        new('name'   => fields[:name],
            'desc'   => fields[:description],
            'closed' => fields[:closed] || false).save!
      end
    end

    def save!
      return update! if id

      fields = { :name => name }
      fields.merge!(:desc => description) if description
      fields.merge!(:idOrganization => organization_id) if organization_id

      Client.post("/boards", fields).json_into(self)
    end

    def update!
      fail "Cannot save new instance." unless self.id

      Client.put("/boards/#{self.id}/", {
        :name        => @name,
        :description => @description,
        :closed      => @closed
      }).json_into(self)
    end

    def update_fields(fields)
      attributes[:id]              = fields['id']              if fields['id']
      attributes[:name]            = fields['name']            if fields['name']
      attributes[:description]     = fields['desc']            if fields['desc']
      attributes[:closed]          = fields['closed']          if fields.has_key?('closed')
      attributes[:url]             = fields['url']             if fields['url']
      attributes[:organization_id] = fields['idOrganization']  if fields['idOrganization']

      self
    end

    def attributes
      @attributes ||= {
        :id              => @id,
        :name            => @name,
        :description     => @description,
        :closed          => @closed,
        :url             => @url,
        :organization_id => @organization_id
      }
    end

    def closed?
      @attributes[:closed]
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

    def has_lists?
      lists.size > 0
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
