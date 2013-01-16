module Trello
  module HasActions
    # Returns a list of the actions associated with this object.
    def actions(options = {})
      actions = client.get("#{request_prefix}/actions", { :filter => :all }.merge(options)).json_into(Action)
      MultiAssociation.new(self, actions).proxy
    end
  end
end
