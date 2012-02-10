module Trello

  class Board < BasicData
    attr_reader :id, :name, :description, :url, :organization_id

    include HasActions

    class << self

      def find(id)
        super(:boards, id)
      end

      def create(attributes)
        new('name'   => attributes[:name],
            'desc'   => attributes[:description],
            'closed' => attributes[:closed] || false).save!
      end
    end

    def save!
      return update! if id

      attributes = { :name => name }
      attributes.merge!(:desc => description) if description
      attributes.merge!(:idOrganization => organization_id) if organization_id

      Client.post("/boards", attributes).json_into(self)
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

    # Return all the cards on this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def cards(options = { :filter => :open })
      Client.get("/boards/#{id}/cards").json_into(Card)
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
      Client.get("/boards/#{id}/lists", options).json_into(List)
    end

    # Returns an array of members who are associated with this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :normal, :owners, :all ] # default :all
    def members(options = { :filter => :all })
      Client.get("/boards/#{id}/members", options).json_into(Member)
    end

    # Returns a reference to the organization this board belongs to.
    def organization
      Organization.find(organization_id)
    end

    # :nodoc:
    def request_prefix
      "/boards/#{id}"
    end
  end
end
