# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class List < BasicData
    class << self
      def find(id)
        super(:lists, id)
      end
    end

    # Fields

    def id
      fields['id']
    end

    def name
      fields['name']
    end

    def closed
      fields['closed']
    end

    # Links to other data structures

    def actions
      return @actions if @actions
      @actions = Client.get("/lists/#{id}/actions").json_into(Actions)
    end

    def board
      return @board if @board
      @board = Board.find(fields['idBoard'])
    end

    def cards
      return @cards if @cards
      @cards = fields['cards'].map { |c| Card.new(c) }
    end
  end
end
