module Trello
  # Organizations are useful for linking members together.
  class Organization < BasicData
    register_attributes :id, :name, :display_name, :description, :url,
      :readonly => [ :id, :name, :display_name, :description, :url ]
    validates_presence_of :id, :name

    include HasActions

    class << self
      # Find an organization by its id.
      def find(id)
        super(:organizations, id)
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
      boards = Client.get("/organizations/#{id}/boards/all").json_into(Board)
      MultiAssociation.new(self, boards).proxy
    end

    # Returns an array of members associated with the organization.
    def members
      members = Client.get("/organizations/#{id}/members/all").json_into(Member)
      MultiAssociation.new(self, members).proxy
    end

    # :nodoc:
    def request_prefix
      "/organizations/#{id}"
    end
  end
end
