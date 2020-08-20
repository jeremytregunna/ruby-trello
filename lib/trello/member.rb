module Trello
  # A Member is a user of the Trello service.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] username
  #   @return [String]
  # @!attribute [rw] email
  #   @return [String]
  # @!attribute [rw] full_name
  #   @return [String]
  # @!attribute [rw] initials
  #   @return [String]
  # @!attribute [r] avatar_id
  #   @return [String]
  # @!attribute [rw] bio
  #   @return [String]
  # @!attribute [r] url
  #   @return [String]
  class Member < BasicDataAlpha
    schema do
      # readonly
      attribute :id, readonly: true, primary_key: true
      attribute :email, readonly: true
      attribute :avatar_id, readonly: true, remote_key: 'avatarHash'
      attribute :url, readonly: true
      attribute :prefs, readonly: true
      attribute :activity_blocked, readonly: true, remote_key: 'activityBlocked'
      attribute :bio_data, readonly: true, remote_key: 'bioData'
      attribute :confirmed, readonly: true
      attribute :enterprise_id, readonly: true, remote_key: 'idEnterprise'
      attribute :deactivated_enterprised_ids, readonly: true, remote_key: 'idEnterprisesDeactivated'
      attribute :referrer_member_id, readonly: true, remote_key: 'idMemberReferrer'
      attribute :admin_orgs_perm_id, readonly: true, remote_key: 'idPremOrgsAdmin'
      attribute :member_type, readonly: true, remote_key: 'memberType'
      attribute :non_public, readonly: true, remote_key: 'nonPublic'
      attribute :non_public_available, readonly: true, remote_key: 'nonPublicAvailable'
      attribute :products, readonly: true
      attribute :status, readonly: true
      attribute :board_ids, readonly: true, remote_key: 'idBoards'
      attribute :organization_ids, readonly: true, remote_key: 'idOrganizations'
      attribute :admin_enterprise_ids, readonly: true, remote_key: 'idEnterprisesAdmin'
      attribute :limits, readonly: true
      attribute :login_type, readonly: true, remote_key: 'loginTypes'
      attribute :marketing_opt_in, readonly: true, remote_key: 'marketingOptIn'
      attribute :pinned_board_ids, readonly: true, remote_key: 'idBoardsPinned'

      # writable
      attribute :username
      attribute :full_name, remote_key: 'fullName'
      attribute :initials
      attribute :bio
      attribute :avatar_source, remote_key: 'avatarSource'
    end

    # register_attributes :id, :username, :email, :full_name, :initials, :avatar_id, :bio, :url, readonly: [ :id, :username, :avatar_id, :url ]
    validates_presence_of :id, :username
    validates_length_of   :full_name, minimum: 4
    validates_length_of   :bio,       maximum: 16384

    include HasActions

    class << self
      # Finds a user
      #
      # The argument may be specified as either an _id_ or a _username_.
      def find(id_or_username, params = {})
        client.find(:member, id_or_username, params)
      end
    end

    # Retrieve a URL to the avatar.
    #
    # Valid values for options are:
    #   :large (170x170)
    #   :small (30x30)
    def avatar_url(options = { size: :large })
      size = options[:size] == :small ? 30 : 170
      "https://trello-avatars.s3.amazonaws.com/#{avatar_id}/#{size}.png"
    end

    # Returns a list of the boards a member is a part of.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #   :filter => [ :none, :members, :organization, :public, :open, :closed, :all ] # default: :all
    # i.e.,
    #    me.boards(:filter => :closed) # retrieves all closed boards
    many :boards, filter: :all

    # Returns a list of cards the member is assigned to.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    # i.e.,
    #    me.cards(:filter => :closed) # retrieves all closed cards
    many :cards, filter: :open

    # Returns a list of the organizations this member is a part of.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #   :filter => [ :none, :members, :public, :all ] # default: all
    # i.e.,
    #    me.organizations(:filter => :public) # retrieves all public organizations
    many :organizations, filter: :all

    # Returns a list of notifications for the user
    many :notifications

    # :nodoc:
    def request_prefix
      "/members/#{id}"
    end
  end
end
