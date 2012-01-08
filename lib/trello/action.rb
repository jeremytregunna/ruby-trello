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
      response = Client.query("/1/actions/#{id}/board")
      Board.new(JSON.parse(response.read_body))
    end

    def card
      response = Client.query("/1/actions/#{id}/card")
      Card.new(JSON.parse(response.read_body))
    end

    def list
      response = Client.query("/1/actions/#{id}/list")
      List.new(JSON.parse(response.read_body))
    end

    def member_creator
      Member.find(fields['idMemberCreator'])
    end
  end
end