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

    def has_lists?
      lists.size > 0
    end

    # Return all the cards on this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :cards, :filter => :open

    # Returns all the lists on this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :lists, :filter => :open

    # Returns an array of members who are associated with this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :normal, :owners, :all ] # default :all
    many :members, :filter => :all

    # Returns a reference to the organization this board belongs to.
    one :organization, :using => :organization_id

    # :nodoc:
    def request_prefix
      "/boards/#{id}"
    end
  end
end
