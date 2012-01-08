# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Card
    class << self
      def find(id)
        response = Client.query("/1/cards/#{id}")
        new(Yajl::Parser.parse(response.read_body))
      end
    end

    def initialize(fields = {})
      @fields = fields
    end

    # Fields

    def id
      @fields['id']
    end

    def name
      @fields['name']
    end

    def description
      @fields['desc']
    end

    def closed
      @fields['closed']
    end

    def url
      @fields['url']
    end

    # Links to other data structures

    def board
      Board.find(@fields['idBoard'])
    end

    def members
      @fields['idMembers'].map do |member_id|
        response  = Client.query("/1/members/#{member_id}")
        Member.new(Yajl::Parser.parse(response.read_body))
      end
    end
  end
end