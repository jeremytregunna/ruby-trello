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
    register_attributes :id, :name, :display_name, :description, :url,
      readonly: [ :id, :name, :display_name, :description, :url ]
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
      attributes[:id]           = fields['id']
      attributes[:name]         = fields['name']
      attributes[:display_name] = fields['displayName']
      attributes[:description]  = fields['description']
      attributes[:url]          = fields['url']
      self
    end

    # Returns a list of boards under this organization.
    def boards
      boards = client.get("/organizations/#{id}/boards/all").json_into(Board)
      MultiAssociation.new(self, boards).proxy
    end

    # Returns an array of members associated with the organization.
    def members(params = {})
      members = client.get("/organizations/#{id}/members/all", params).json_into(Member)
      MultiAssociation.new(self, members).proxy
    end

    # :nodoc:
    def request_prefix
      "/organizations/#{id}"
    end
  end
end
