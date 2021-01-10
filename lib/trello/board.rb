module Trello

  # A board on Trello
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] starred
  #   @return [Boolean]
  # @!attribute [r] pinned
  #   @return [Boolean]
  # @!attribute [r] url
  #   @return [String]
  # @!attribute [r] short_url
  #   @return [String]
  # @!attribute [r] prefs
  #   @return [Hash]
  # @!attribute [r] last_activity_date
  #   @return [Datetime]
  # @!attribute [r] description_data
  #   @return [Datetime]
  # @!attribute [r] enterprise_id
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] description
  #   @return [String]
  # @!attribute [rw] organization_id
  #   @return [String]
  # @!attribute [rw] visibility_level
  #   @return [String]
  # @!attribute [rw] voting_permission_level
  #   @return [String]
  # @!attribute [rw] comment_permission_level
  #   @return [String]
  # @!attribute [rw] invitation_permission_level
  #   @return [String]
  # @!attribute [rw] enable_self_join
  #   @return [Boolean]
  # @!attribute [rw] enable_card_covers
  #   @return [Boolean]
  # @!attribute [rw] background_color
  #   @return [String]
  # @!attribute [rw] background_image
  #   @return [String]
  # @!attribute [rw] card_aging_type
  #   @return [String]
  # @!attribute [w] use_default_labels
  #   @return [Boolean]
  # @!attribute [w] use_default_lists
  #   @return [Boolean]
  # @!attribute [w] source_board_id
  #   @return [String]
  # @!attribute [w] keep_cards_from_source
  #   @return [String]
  # @!attribute [w] power_ups
  #   @return [String]
  # @!attribute [rw] closed
  #   @return [Boolean]
  # @!attribute [w] subscribed
  #   @return [Boolean]
  class Board < BasicData
    schema do
      attribute :id, readonly: true, primary_key: true

      # Readonly
      attribute :starred, readonly: true
      attribute :pinned, readonly: true
      attribute :url, readonly: true
      attribute :short_url, readonly: true, remote_key: 'shortUrl'
      attribute :prefs, readonly: true, default: {}
      attribute :last_activity_date, readonly: true, remote_key: 'dateLastActivity', serializer: 'Time'
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
      # @return [Array<Trello::Board>] all boards for the current user
      def all
        from_response client.get("/members/#{Member.find(:me).username}/boards")
      end
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

  end
end
