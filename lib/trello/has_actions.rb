module Trello
  module HasActions
    # Returns a list of the actions associated with this object.
    def actions(options = {})
      Client.get("/cards/#{id}/actions", { :filter => :all }.merge(options)).json_into(Action)
    end
  end
end
