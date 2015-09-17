module Trello
  # Action represents some event that occurred. For instance, when a card is created.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] type
  #   @return [String]
  # @!attribute [r] data
  #   @return [Hash]
  # @!attribute [r] date
  #   @return [Datetime]
  # @!attribute [r] member_creator_id
  #   @return [String]
  # @!attribute [r] member_participant
  #   @return [Object]
  class Action < BasicData
    register_attributes :id, :type, :data, :date, :member_creator_id, :member_participant,
      readonly: [ :id, :type, :data, :date, :member_creator_id, :member_participant ]
    validates_presence_of :id, :type, :date, :member_creator_id

    class << self
      # Locate a specific action and return a new Action object.
      def find(id, params = {})
        client.find(:action, id, params)
      end

      def search(query, opts={})
        response = client.get("/search/", { query: query }.merge(opts))
        JSON.parse(response).except("options").inject({}) do |res, key|
          res.merge({ key.first => key.last.jsoned_into("Trello::#{key.first.singularize.capitalize}".constantize) })
        end
      end
    end

    # Update the attributes of an action
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an Action.
    def update_fields(fields)
      attributes[:id]                 = fields['id']
      attributes[:type]               = fields['type']
      attributes[:data]               = fields['data']
      attributes[:date]               = Time.iso8601(fields['date'])
      attributes[:member_creator_id]  = fields['idMemberCreator']
      attributes[:member_participant] = fields['member']
      self
    end

    # Returns the board this action occurred on.
    def board
      client.get("/actions/#{id}/board").json_into(Board)
    end

    # Returns the card the action occurred on.
    def card
      client.get("/actions/#{id}/card").json_into(Card)
    end

    # Returns the list the action occurred on.
    def list
      client.get("/actions/#{id}/list").json_into(List)
    end

    # Returns the member who created the action.
    one :member_creator, via: Member, path: :members, using: :member_creator_id
  end
end
