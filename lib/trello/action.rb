# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Action < BasicData
    class << self
      def find(id)
        super(:actions, id)
      end
    end

    # Fields

    def id
      fields['id']
    end

    def type
      fields['type']
    end

    def data
      fields['data']
    end

    # Links to other data structures

    def board
      return @board if @board

      response = Client.get("/1/actions/#{id}/board")
      @board = Board.new(JSON.parse(response.read_body))
    end

    def card
      return @card if @card

      response = Client.get("/1/actions/#{id}/card")
      @card = Card.new(JSON.parse(response.read_body))
    end

    def list
      return @list if @list

      response = Client.get("/1/actions/#{id}/list")
      @list = List.new(JSON.parse(response.read_body))
    end

    def member_creator
      return @member_creator if @member_creator

      @member_creator = Member.find(fields['idMemberCreator'])
    end
  end
end
