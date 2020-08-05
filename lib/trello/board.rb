module Trello

  # A board on Trello
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] name
  #   @return [String]
  # @!attribute [rw] description
  #   @return [String]
  # @!attribute [rw] closed
  #   @return [Boolean]
  # @!attribute [r] url
  #   @return [String]
  # @!attribute [rw] organization_id
  #   @return [String] A 24-character hex string
  # @!attribute [r] prefs
  #   @return [Hash] A 24-character hex string
  class Board < BasicData
    schema do
      attribute :id, readonly: true, primary_key: true

      # Readonly
      attribute :starred, readonly: true
      attribute :pinned, readonly: true
      attribute :url, readonly: true
      attribute :short_url, readonly: true, remote_key: 'shortUrl'
      attribute :prefs, readonly: true
      attribute :last_activity_date, readonly: true, remote_key: 'dateLastActivity'
      attribute :description_data, readonly: true, remote_key: 'descData'
      attribute :enterprise_id, readonly: true, remote_key: 'idEnterprise'

      # Writable
      attribute :name
      attribute :description, remote_key: 'desc'
      attribute :organization_id, remote_key: 'idOrganization'
      attribute :visibility_level, remote_key: 'permissionLevel', class_name: 'BoardPref'
      attribute :voting_permission_level, remote_key: 'voting', class_name: 'BoardPref'
      attribute :comment_permission_level, remote_key: 'comments', class_name: 'BoardPref'
      attribute :invitation_permission_level, remote_key: 'invitations', class_name: 'BoardPref'
      attribute :enable_self_join, remote_key: 'selfJoin', class_name: 'BoardPref'
      attribute :enable_card_covers, remote_key: 'cardCovers', class_name: 'BoardPref'
      attribute :background_color, remote_key: 'background', class_name: 'BoardPref'
      attribute :background_image, remote_key: 'backgroundImage', class_name: 'BoardPref'
      attribute :card_aging_type, remote_key: 'cardAging', class_name: 'BoardPref'

      # Writable but for create only
      attribute :use_default_labels, create_only: true, remote_key: 'defaultLabels'
      attribute :use_default_lists, create_only: true, remote_key: 'defaultLists'
      attribute :source_board_id, create_only: true, remote_key: 'idBoardSource'
      attribute :keep_cards_from_source, create_only: true, remote_key: 'keepFromSource'
      attribute :power_ups, create_only: true, remote_key: 'powerUps'

      # Writable but for update only
      attribute :closed, update_only: true
      attribute :subscribed, update_only: true
    end

    validates_presence_of :id, :name
    validates_length_of   :name,        in: 1..16384
    validates_length_of   :description, maximum: 16384

    include HasActions

    class << self
      # Finds a board.
      #
      # @param [String] id Either the board's short ID (an alphanumeric string,
      #     found e.g. in the board's URL) or its long ID (a 24-character hex
      #     string.)
      # @param [Hash] params
      #
      # @raise  [Trello::Board] if a board with the given ID could not be found.
      #
      # @return [Trello::Board]
      def find(id, params = {})
        client.find(:board, id, params)
      end

      def create(fields)
        client.create(:board, fields)
      end

      # @return [Array<Trello::Board>] all boards for the current user
      def all
        from_response client.get("/members/#{Member.find(:me).username}/boards")
      end
    end

    def initialize(fields = {})
      initialize_fields(fields)
    end

    def save
      return update! if id

      mapper = {
        name: 'name',
        use_default_labels: 'defaultLabels',
        use_default_lists: 'defaultLists',
        description: 'desc',
        organization_id: 'idOrganization',
        source_board_id: 'idBoardSource',
        keep_cards_from_source: 'keepFromSource',
        power_ups: 'powerUps',
        visibility_level: 'prefs_permissionLevel',
        voting_permission_level: 'prefs_voting',
        comment_permission_level: 'prefs_comments',
        invitation_permission_level: 'prefs_invitations',
        enable_self_join: 'prefs_selfJoin',
        enable_card_covers: 'prefs_cardCovers',
        background_color: 'prefs_background',
        card_aging_type: 'prefs_cardAging'
      }

      payload = {}

      %i[
        name organization_id visibility_level voting_permission_level
        comment_permission_level invitation_permission_level
        enable_self_join enable_card_covers
        background_color card_aging_type
        use_default_labels use_default_lists
        source_board_id keep_cards_from_source
        power_ups
      ].each do |attr_name|
        attr_value = send(attr_name)
        next if attr_value.in?([nil, ''])

        payload[mapper[attr_name]] = attr_value
      end

      payload[mapper[:description]] = description

      post('/boards', payload)
    end

    def update!
      fail "Cannot save new instance." unless id

      @previously_changed = changes

      payload = {}
      changed_attrs = attributes.select {|name, _| changed.include?(name.to_s)}

      schema.attrs.each do |_, attribute|
        payload = attribute.build_payload_for_update(changed_attrs, payload)
      end

      from_response_v2 client.put("/boards/#{id}/", payload)

      @changed_attributes.clear if @changed_attributes.respond_to?(:clear)
      changes_applied if respond_to?(:changes_applied)

      self
    end

    def update_fields(fields)
      attrs = {}

      schema.attrs.each do |_, attribute|
        attrs = attribute.build_pending_update_attributes(fields, attrs)
      end

      attrs.each do |name, value|
        send("#{name}=", value)
      end

      self
    end

    # @return [Boolean]
    def closed?
      attributes[:closed]
    end

    # @return [Boolean]
    def starred?
      attributes[:starred]
    end

    # @return [Boolean]
    def has_lists?
      lists.size > 0
    end

    # Find a card on this Board with the given ID.
    # @return [Trello::Card]
    def find_card(card_id)
      Card.from_response client.get("/boards/#{self.id}/cards/#{card_id}")
    end

    # Add a member to this Board.
    #    type => [ :admin, :normal, :observer ]
    def add_member(member, type = :normal)
      client.put("/boards/#{self.id}/members/#{member.id}", { type: type })
    end

    # Remove a member of this Board.
    def remove_member(member)
      client.delete("/boards/#{self.id}/members/#{member.id}")
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
    #    :filter => [ :none, :normal, :owners, :admins, :all ] # default :all
    many :members, filter: :all

    # Returns a list of checklists associated with the board.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :all ] # default :all
    many :checklists, filter: :all

    # Returns a reference to the organization this board belongs to.
    one :organization, path: :organizations, using: :organization_id

    # Returns a list of plugins associated with the board
    many :plugin_data, path: "pluginData"

    # Returns custom fields activated on this board
    many :custom_fields, path: "customFields"

    def labels(params = {})
      # Set the limit to as high as possible given there is no pagination in this API.
      params[:limit] = 1000 unless params[:limit]
      labels = Label.from_response client.get("/boards/#{id}/labels", params)
      MultiAssociation.new(self, labels).proxy
    end

    def label_names
      label_names = LabelName.from_response client.get("/boards/#{id}/labelnames")
      MultiAssociation.new(self, label_names).proxy
    end

    # :nodoc:
    def request_prefix
      "/boards/#{id}"
    end

    private

    def initialize_fields(fields)
      schema.attrs.each do |_, attribute|
        self.attributes = attribute.build_attributes(fields, attributes)
      end

      self
    end

    def post(path, body)
      from_response_v2 client.post(path, body)
    end
  end
end
