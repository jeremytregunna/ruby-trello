# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class List < BasicData
    attr_reader :id, :name, :closed, :board_id

    class << self
      def find(id)
        super(:lists, id)
      end
    end

    def initialize(fields = {})
      @id            = fields['id']
      @name          = fields['name']
      @closed        = fields['closed']
      @board_id      = fields['idBoard']
      @list_of_cards = fields['cards']
    end

    def closed?
      closed
    end

    # Links to other data structures

    def actions
      return @actions if @actions
      @actions = Client.get("/lists/#{id}/actions").json_into(Actions)
    end

    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    def cards
      return @cards if @cards
      @cards = @list_of_cards.map { |c| Card.new(c) }
    end
  end
end
