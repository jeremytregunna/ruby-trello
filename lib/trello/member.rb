# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Member < BasicData
    class << self
      def find(id_or_username)
        super(:members, id_or_username)
      end
    end

    def initialize(fields = {})
      @fields = fields
    end

    # Fields of a user

    def id
      @fields['id']
    end

    def full_name
      @fields['fullName']
    end

    def username
      @fields['username']
    end

    def gravatar_id
      @fields['gravatar']
    end

    def bio
      @fields['bio']
    end

    def url
      @fields['url']
    end

    # Links to other data structures

    def boards
      response = Client.query("/1/members/#{username}/boards/all")
      JSON.parse(response.read_body).map do |board_fields|
        Board.new(board_fields)
      end
    end

    def cards
      response = Client.query("/1/members/#{username}/cards/all")
      JSON.parse(response.read_body).map do |card_fields|
        Card.new(card_fields)
      end
    end

    def organizations
      response = Client.query("/1/members/#{username}/organizations/all")
      JSON.parse(response.read_body).map do |org_fields|
        Organization.new(org_fields)
      end
    end
  end
end