# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Board < BasicData
    class << self
      def find(id)
        response = Client.query("/1/boards/#{id}")
        new(JSON.parse(response.read_body))
      end
    end

    # Fields

    def id
      fields['id']
    end

    def name
      fields['name']
    end

    def description
      fields['desc']
    end

    def closed
      fields['closed']
    end

    def url
      fields['url']
    end

    # Links to other data structures

    def cards
      response = Client.query("/1/boards/#{id}/cards/all")
      JSON.parse(response.read_body).map do |card_fields|
        Card.new(card_fields)
      end
    end

    def lists
      response = Client.query("/1/boards/#{id}/lists/all")
      JSON.parse(response.read_body).map do |list_fields|
        List.new(list_fields)
      end
    end

    def members
      response = Client.query("/1/boards/#{id}/members/all")
      JSON.parse(response.read_body).map do |member_fields|
        Member.new(member_fields)
      end
    end

    def organization
      Organization.find(fields['idOrganization'])
    end
  end
end