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
    register_attributes :id, :name, :description, :closed, :starred, :url,
                        :organization_id, :prefs, :last_activity_date, :description_data,
                        :enterprise_id, :pinned, :short_url,
                        :visibility_level, :voting_permission_level, :comment_permission_level,
                        :invitation_permission_level, :enable_self_join,
                        :enable_card_covers, :background_color, :background_image,
                        :card_aging_type,
      readonly: [
        :id, :url, :last_activity_date, :description_data, :enterprise_id, :pinned,
        :short_url, :prefs
      ]
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
        data = {}
        mapper.each do |attr, api_field|
          data[api_field] = fields[attr] if fields.key?(attr)
        end
        client.create(:board, data)
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
        name description organization_id
        visibility_level voting_permission_level
        comment_permission_level invitation_permission_level
        enable_self_join enable_card_covers
        background_color card_aging_type
      ].each do |attr_name|
        payload[mapper[attr_name]] = send(attr_name)
      end

      post('/boards', payload)
    end

    def update!
      fail "Cannot save new instance." unless id

      @previously_changed = changes

      payload = Hash[
        changes.map do |key, values|
          if SYMBOL_TO_STRING.keys.include?(key.to_sym)
            [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]]
          elsif MAP_PREFS_ATTRIBUTE.keys.include?(key.to_sym)
            [:"prefs/#{MAP_PREFS_ATTRIBUTE[key.to_sym]}", values[1]]
          end
        end
      ]

      from_response_v2 client.put("/boards/#{id}/", payload)

      @changed_attributes.clear if @changed_attributes.respond_to?(:clear)
      changes_applied if respond_to?(:changes_applied)

      self
    end

    def update_fields(fields)
      %i[
        name description closed starred organization_id
      ].each do |attr_key|
        send("#{attr_key}=", parse_writable_fields(fields, attr_key))
      end

      %i[
        visibility_level voting_permission_level comment_permission_level
        invitation_permission_level enable_self_join
        enable_card_covers background_color background_image
        card_aging_type
      ].each do |attr_key|
        send("#{attr_key}=", parse_prefs_fields(fields, attr_key))
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
      %i[
        id url description_data enterprise_id pinned short_url prefs
      ].each do |attr_key|
        attributes[attr_key] = parse_readonly_fields(fields, attr_key)
      end

      %i[
        name description closed starred organization_id last_activity_date
      ].each do |attr_key|
        attributes[attr_key] = parse_writable_fields(fields, attr_key)
      end

      %i[
        visibility_level voting_permission_level comment_permission_level
        invitation_permission_level enable_self_join
        enable_card_covers background_color background_image
        card_aging_type
      ].each do |attr_key|
        attributes[attr_key] = parse_prefs_fields(fields, attr_key)
      end

      attributes[:last_activity_date] = serialize_time(attributes[:last_activity_date])
      attributes[:prefs] ||= {}
      attributes[:background_color] = serialize_background_color(attributes[:background_color])
      self
    end

    SYMBOL_TO_STRING = {
      id: :id,
      name: :name,
      description: :desc,
      description_data: :descData,
      enterprise_id: :idEnterprise,
      pinned: :pinned,
      url: :url,
      short_url: :shortUrl,
      closed: :closed,
      starred: :starred,
      organization_id: :idOrganization,
      prefs: :prefs,
      last_activity_date: :dateLastActivity
    }

    MAP_PREFS_ATTRIBUTE = {
      visibility_level: :permissionLevel,
      voting_permission_level: :voting,
      comment_permission_level: :comments,
      invitation_permission_level: :invitations,
      enable_self_join: :selfJoin,
      enable_card_covers: :cardCovers,
      background_color: :background,
      background_image: :backgroundImage,
      card_aging_type: :cardAging
    }

    def parse_writable_fields(fields, key)
      fields = (fields || {}).transform_keys(&:to_sym)

      gem_version_key = key.to_sym
      api_version_key = SYMBOL_TO_STRING[gem_version_key]

      if fields.key?(api_version_key)
        fields[api_version_key]
      elsif fields.key?(gem_version_key)
        fields[gem_version_key]
      else
        attributes[gem_version_key]
      end
    end

    def parse_readonly_fields(fields, key)
      fields = (fields || {}).transform_keys(&:to_sym)

      gem_version_key = key.to_sym
      api_version_key = SYMBOL_TO_STRING[gem_version_key]

      if fields.key?(api_version_key)
        fields[api_version_key]
      else
        attributes[gem_version_key]
      end
    end

    def parse_prefs_fields(fields, key)
      fields = (fields || {}).transform_keys(&:to_sym)
      preferences = (prefs || {}).transform_keys(&:to_sym)

      gem_version_key = key.to_sym
      api_version_key = MAP_PREFS_ATTRIBUTE[gem_version_key]

      if preferences.key?(api_version_key)
        preferences[api_version_key]
      elsif fields.key?(gem_version_key)
        fields[gem_version_key]
      else
        attributes[gem_version_key]
      end
    end

    def serialize_time(time)
      return time unless time.is_a?(String)

      Time.iso8601(time) rescue nil
    end

    def serialize_background_color(color)
      default_colors = %w[blue orange green red purple pink lime sky grey]
      return color if default_colors.include?(color.to_s)
    end

    # On creation
    # https://trello.com/docs/api/board/#post-1-boards
    # - permissionLevel
    # - voting
    # - comments
    # - invitations
    # - selfJoin
    # - cardCovers
    # - background
    # - cardAging
    #
    # On update
    # https://trello.com/docs/api/board/#put-1-boards-board-id
    # Same as above plus:
    # - calendarFeedEnabled
    def flat_prefs
      separator = id ? "/" : "_"
      attributes[:prefs].inject({}) do |hash, (pref, v)|
        hash.merge("prefs#{separator}#{pref}" => v)
      end
    end

    def post(path, body)
      from_response_v2 client.post(path, body)
    end
  end
end
