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
  class Organization < BasicData
    register_attributes :id, :name, :display_name, :description, :url, :invited,
      :website, :logo_hash, :billable_member_count, :active_billable_member_count,
      :memberships,
      readonly: [ :id, :name, :display_name, :description, :url, :invited,
        :website, :logo_hash, :billable_member_count, :active_billable_member_count,
        :memberships ]
    validates_presence_of :id, :name

    include HasActions

    class << self
      # Find an organization by its id.
      def find(id, params = {})
        client.find(:organization, id, params)
      end
    end

    # Update the fields of an organization.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an Organization.
    def update_fields(fields)
      attributes[:id]                           = fields['id'] || attributes[:id]
      attributes[:name]                         = fields['name'] || attributes[:name]
      attributes[:display_name]                 = fields['displayName'] || attributes[:display_name]
      attributes[:description]                  = fields['desc'] || attributes[:description]
      attributes[:url]                          = fields['url'] || attributes[:url]
      attributes[:invited]                      = fields['invited'] if fields.has_key?('invited')
      attributes[:website]                      = fields['website'] || attributes[:website]
      attributes[:logo_hash]                    = fields['logoHash'] || attributes[:logo_hash]
      attributes[:billable_member_count]        = fields['billableMemberCount'] || attributes[:billable_member_count]
      attributes[:active_billable_member_count] = fields['activeBillableMemberCount'] || attributes[:active_billable_member_count]
      attributes[:memberships]                  = fields['memberships'] || attributes[:memberships]
      self
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
