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
  # @!attribute [r] creator_id
  #   @return [String]
  # @!attribute [r] member_participant
  #   @return [Object]
  class Action < BasicData

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :creator_id, readonly: true, remote_key: 'idMemberCreator'
      attribute :data, readonly: true
      attribute :type, readonly: true
      attribute :date, readonly: true, serializer: 'Time'
      attribute :limits, readonly: true
      attribute :app_creator, readonly: true, remote_key: 'appCreator'
      attribute :display, readonly: true

      # Writable
      attribute :text, update_only: true
    end

    validates_presence_of :id, :type, :date, :creator_id

    class << self
      # Locate a specific action and return a new Action object.
      def find(id, params = {})
        client.find(:action, id, params)
      end

      def search(query, opts = {})
        response = client.get("/search/", { query: query }.merge(opts))
        parse_json(response).except("options").each_with_object({}) do |(key, data), result|
          klass = "Trello::#{key.singularize.capitalize}".constantize
          result[key] = klass.from_json(data)
        end
      end
    end

    # Returns the board this action occurred on.
    def board
      Board.from_response client.get("/actions/#{id}/board")
    end

    # Returns the card the action occurred on.
    def card
      Card.from_response client.get("/actions/#{id}/card")
    end

    # Returns the list the action occurred on.
    def list
      List.from_response client.get("/actions/#{id}/list")
    end

    # Returns the list the action occurred on.
    def member_creator
      Member.from_response client.get("/actions/#{id}/memberCreator")
    end
  end
end
