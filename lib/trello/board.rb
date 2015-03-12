module Trello
  class Board < BasicData
    register_attributes :id, :name, :description, :closed, :url, :organization_id, :prefs,
      readonly: [ :id, :url, :prefs ]
    validates_presence_of :id, :name
    validates_length_of   :name,        in: 1..16384
    validates_length_of   :description, maximum: 16384

    include HasActions

    class << self
      # Finds a board.
      #
      # @return [Trello::Board]
      def find(id, params = {})
        client.find(:board, id, params)
      end

      def create(fields)
        data = {
          'name'   => fields[:name],
          'desc'   => fields[:description],
          'closed' => fields[:closed] || false }
        data.merge!('idOrganization' => fields[:organization_id]) if fields[:organization_id]
        client.create(:board, data)
      end

      # @return [Array<Trello::Board>] all boards for the current user
      def all
        client.get("/members/#{Member.find(:me).username}/boards").json_into(self)
      end
    end

    def save
      return update! if id

      fields = { name: name }
      fields.merge!(desc: description) if description
      fields.merge!(idOrganization: organization_id) if organization_id

      client.post("/boards", fields).json_into(self)
    end

    def update!
      fail "Cannot save new instance." unless self.id

      @previously_changed = changes
      @changed_attributes.clear

      client.put("/boards/#{self.id}/", {
        name: attributes[:name],
        description: attributes[:description],
        closed: attributes[:closed],
        idOrganization: attributes[:organization_id]
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

    # @return [Boolean]
    def closed?
      attributes[:closed]
    end

    # @return [Boolean]
    def has_lists?
      lists.size > 0
    end

    # Find a card on this Board with the given ID.
    # @return [Trello::Card]
    def find_card(card_id)
      client.get("/boards/#{self.id}/cards/#{card_id}").json_into(Card)
    end

    # Return all the cards on this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :cards, filter: :open

    # Returns all the lists on this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :lists, filter: :open

    # Returns an array of members who are associated with this board.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :normal, :owners, :all ] # default :all
    many :members, filter: :all

    # Returns a reference to the organization this board belongs to.
    one :organization, path: :organizations, using: :organization_id

    many :labels

    # :nodoc:
    def request_prefix
      "/boards/#{id}"
    end
  end
end
