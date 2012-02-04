module Trello
  # A List is a container which holds cards. Lists are items on a board.
  class List < BasicData
    attr_reader :id, :name, :closed, :board_id

    class << self
      # Finds a specific list, given an id.
      def find(id)
        super(:lists, id)
      end

      def create(options)
        new('name'    => options[:name],
            'idBoard' => options[:board_id]).save!
      end
    end

    # Updates the fields of a list.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a List.
    def update_fields(fields)
      @id       = fields['id']
      @name     = fields['name']
      @closed   = fields['closed']
      @board_id = fields['idBoard']
      self
    end

    def save!
      return update! if id

      Client.post("/lists", {
        :name    => @name,
        :closed  => @closed || false,
        :idBoard => @board_id
      }).json_into(self)
    end

    def update!
    end

    # Check if the list is not active anymore.
    def closed?
      closed
    end

    # Return a timeline of events related to this list.
    def actions
      return @actions if @actions
      @actions = Client.get("/lists/#{id}/actions").json_into(Action)
    end

    # Return the board the list is connected to.
    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    # Returns all the cards on this list.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def cards(options = { :filter => :open })
      return @cards if @cards
      @cards = Client.get("/lists/#{id}/cards", options).json_into(Card)
    end
  end
end
