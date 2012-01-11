module Trello
  # Organizations are useful for linking members together.
  class Organization < BasicData
    attr_reader :id, :name, :display_name, :description, :url

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
    end

    # Returns a timeline of actions.
    def actions
      return @actions if @actions
      @actions = Client.get("/organizations/#{id}/actions").json_into(Action)
    end

    # Returns a list of boards under this organization.
    def boards
      return @boards if @boards
      @boards = Client.get("/organizations/#{id}/boards/all").json_into(Board)
    end

    # Returns an array of members associated with the organization.
    def members
      return @members if @members
      @members = Client.get("/organizations/#{id}/members/all").json_into(Member)
    end
  end
end
