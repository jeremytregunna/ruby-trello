module Trello
  # Action represents some event that occurred. For instance, when a card is created.
  class Action < BasicData
    attr_reader :id, :type, :data, :member_creator_id

    class << self
      # Locate a specific action and return a new Action object.
      def find(id)
        super(:actions, id)
      end
    end

    # Creates a new action
    #
    # Optionally supply a hash of string keyed data retrieved from the Trello API
    # representing an Action.
    def initialize(fields = {})
      @id                = fields['id']
      @type              = fields['type']
      @data              = fields['data']
      @member_creator_id = fields['idMemberCreator']
    end

    # Returns the board this action occurred on.
    def board
      return @board if @board
      @board = Client.get("/actions/#{id}/board").json_into(Board)
    end

    # Returns the card the action occurred on.
    def card
      return @card if @card
      @card = Client.get("/actions/#{id}/card").json_into(Card)
    end

    # Returns the list the action occurred on.
    def list
      return @list if @list
      @list = Client.get("/actions/#{id}/list").json_into(List)
    end

    # Returns the member who created the action.
    def member_creator
      return @member_creator if @member_creator
      @member_creator = Member.find(member_creator_id)
    end
  end
end
