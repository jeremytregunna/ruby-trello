module Trello
  # A List is a container which holds cards. Lists are items on a board.
  class List < BasicData
    attr_reader :id, :name, :closed, :board_id

    class << self
      # Finds a specific list, given an id.
      def find(id)
        super(:lists, id)
      end
    end

    # Creates a new List.
    #
    # Optionally supply a hash of string keyed data retrieved from the Trello API
    # representing a List.
    def initialize(fields = {})
      @id            = fields['id']
      @name          = fields['name']
      @closed        = fields['closed']
      @board_id      = fields['idBoard']
      @list_of_cards = fields['cards']
    end

    # Check if the list is not active anymore.
    def closed?
      closed
    end

    # Return a timeline of events related to this list.
    def actions
      return @actions if @actions
      @actions = Client.get("/lists/#{id}/actions").json_into(Actions)
    end

    # Return the board the list is connected to.
    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    # Returns all the cards on this list.
    def cards
      return @cards if @cards
      @cards = @list_of_cards.map { |c| Card.new(c) }
    end
  end
end
