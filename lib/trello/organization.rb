module Trello
  # Organizations are useful for linking members together.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] name
  #   @return [String]
  # @!attribute [r] display_name
  #   @return [String]
  # @!attribute [r] description
  #   @return [String]
  # @!attribute [r] url
  #   @return [String]
  class Organization < BasicDataAlpha
    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :team_type, readonly: true, remote_key: 'teamType'
      attribute :url, readonly: true
      attribute :desc_data, readonly: true, remote_key: 'descData'
      attribute :logo_hash, readonly: true, remote_key: 'logoHash'
      attribute :logo_url, readonly: true, remote_key: 'logoUrl'
      attribute :products, readonly: true
      attribute :power_ups, readonly: true, remote_key: 'powerUps'

      # Writable
      attribute :name
      attribute :display_name, remote_key: 'displayName'
      attribute :description, remote_key: 'desc'
      attribute :website

      # Writable but update only
      attribute :google_app_domain, update_only: true, remote_key: 'associatedDomain', class_name: 'BoardPref'
      attribute :google_app_version, update_only: true, remote_key: 'googleAppsVersion ', class_name: 'BoardPref'
      attribute :enable_add_external_members, update_only: true, remote_key: 'externalMembersDisabled', class_name: 'BoardPref'
      attribute :private_board_creation_permission_level, update_only: true, remote_key: 'boardVisibilityRestrict/private', class_name: 'BoardPref'
      attribute :organization_visible_board_creation_permission_level, update_only: true, remote_key: 'boardVisibilityRestrict/org', class_name: 'BoardPref'
      attribute :public_board_creation_permission_level, update_only: true, remote_key: 'boardVisibilityRestrict/public', class_name: 'BoardPref'
      attribute :visibility_level, update_only: true, remote_key: 'permissionLevel ', class_name: 'BoardPref'
    end

    validates_presence_of :id, :name

    include HasActions

    class << self
      # Find an organization by its id.
      def find(id, params = {})
        client.find(:organization, id, params)
      end
    end

    # Returns a list of boards under this organization.
    def boards
      boards = Board.from_response client.get("/organizations/#{id}/boards/all")
      MultiAssociation.new(self, boards).proxy
    end

    # Returns an array of members associated with the organization.
    def members(params = {})
      members = Member.from_response client.get("/organizations/#{id}/members/all", params)
      MultiAssociation.new(self, members).proxy
    end

    # :nodoc:
    def request_prefix
      "/organizations/#{id}"
    end
  end
end
