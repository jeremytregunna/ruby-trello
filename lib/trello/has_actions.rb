module Trello
  module HasActions
    # Returns a list of the actions associated with this object.
    def actions(options = {})
      actions = Action.from_response client.get("#{request_prefix}/actions", { filter: :all }.merge(options))
      MultiAssociation.new(self, actions).proxy
    end
  end
end
