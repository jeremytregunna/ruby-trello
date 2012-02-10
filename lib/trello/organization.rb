module Trello
  # Organizations are useful for linking members together.
  class Organization < BasicData
    attr_reader :id, :name, :display_name, :description, :url

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
      @id           = fields['id']
      @name         = fields['name']
      @display_name = fields['displayName']
      @description  = fields['description']
      @url          = fields['url']
      self
    end

    # Returns a list of boards under this organization.
    def boards
      Client.get("/organizations/#{id}/boards/all").json_into(Board)
    end

    # Returns an array of members associated with the organization.
    def members
      Client.get("/organizations/#{id}/members/all").json_into(Member)
    end

    # :nodoc:
    def request_prefix
      "/organizations/#{id}"
    end
  end
end
