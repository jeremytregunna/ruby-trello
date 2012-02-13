module Trello
  class Board < BasicData
    register_attributes :id, :name, :description, :closed, :url, :organization_id, :prefs,
      :readonly => [ :id, :url, :organization_id, :prefs ]
    validates_presence_of :id, :name
    validates_length_of   :name,        :in      => 1..16384
    validates_length_of   :description, :maximum => 16384

    include HasActions

    class << self
      # Finds a board.
      def find(id)
        super(:boards, id)
      end

      def create(fields)
        new('name'   => fields[:name],
            'desc'   => fields[:description],
            'closed' => fields[:closed] || false).save
      end
    end

    def save
      return update! if id

      fields = { :name => name }
      fields.merge!(:desc => description) if description
      fields.merge!(:idOrganization => organization_id) if organization_id

      Client.post("/boards", fields).json_into(self)
    end

    def update!
      fail "Cannot save new instance." unless self.id

      @previously_changed = changes
      @changed_attributes.clear

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
      attributes[:prefs]           = fields['prefs'] || {}
      self
    end

    def closed?
      attributes[:closed]
    end

    # Return all the cards on this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def cards(options = { :filter => :open })
      cards = Client.get("/boards/#{id}/cards").json_into(Card)
      MultiAssociation.new(self, cards).proxy
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
      lists = Client.get("/boards/#{id}/lists", options).json_into(List)
      MultiAssociation.new(self, lists).proxy
    end

    # Returns an array of members who are associated with this board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :normal, :owners, :all ] # default :all
    def members(options = { :filter => :all })
      members = Client.get("/boards/#{id}/members", options).json_into(Member)
      MultiAssociation.new(self, members).proxy
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
