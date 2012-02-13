module Trello
  # Action represents some event that occurred. For instance, when a card is created.
  class Action < BasicData
    register_attributes :id, :type, :data, :date, :member_creator_id,
      :readonly => [ :id, :type, :data, :date, :member_creator_id ]
    validates_presence_of :id, :type, :date, :member_creator_id

    class << self
      # Locate a specific action and return a new Action object.
      def find(id)
        super(:actions, id)
      end
    end

    # Update the attributes of an action
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an Action.
    def update_fields(fields)
      attributes[:id]                = fields['id']
      attributes[:type]              = fields['type']
      attributes[:data]              = fields['data']
      attributes[:date]              = Time.iso8601(fields['date'])
      attributes[:member_creator_id] = fields['idMemberCreator']
      self
    end

    # Returns the board this action occurred on.
    def board
      Client.get("/actions/#{id}/board").json_into(Board)
    end

    # Returns the card the action occurred on.
    def card
      Client.get("/actions/#{id}/card").json_into(Card)
    end

    # Returns the list the action occurred on.
    def list
      Client.get("/actions/#{id}/list").json_into(List)
    end

    # Returns the member who created the action.
    one :member_creator, :via => Member, :using => :member_creator_id
  end
end
