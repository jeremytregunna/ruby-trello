# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Organization < BasicData
    class << self
      def find(id)
        super(:organizations, id)
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

    def display_name
      @fields['display_name']
    end

    def description
      @fields['desc']
    end

    def url
      @fields['url']
    end

    # Links to other data structures

    def boards
      response = Client.query("/1/organizations/#{id}/boards/all")
      Yajl::Parser.parse(response.read_body).map do |board_fields|
        Board.new(board_fields)
      end
    end

    def members
      response = Client.query("/1/organizations/#{id}/members/all")
      Yajl::Parser.parse(response.read_body).map do |member_fields|
        Member.new(member_fields)
      end
    end
  end
end