# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Board < BasicData
    class << self
      def find(id)
        super(:boards, id)
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

    def actions
      return @actions if @actions

      response = Client.get("/1/boards/#{id}/actions")
      @actions = JSON.parse(response.read_body).map do |action_fields|
        Action.new(action_fields)
      end
    end

    def cards
      return @cards if @cards

      response = Client.get("/1/boards/#{id}/cards/all")
      @cards = JSON.parse(response.read_body).map do |card_fields|
        Card.new(card_fields)
      end
    end

    def lists
      return @lists if @lists

      response = Client.get("/1/boards/#{id}/lists/all")
      @lists = JSON.parse(response.read_body).map do |list_fields|
        List.new(list_fields)
      end
    end

    def members
      return @members if @members

      response = Client.get("/1/boards/#{id}/members/all")
      @members = JSON.parse(response.read_body).map do |member_fields|
        Member.new(member_fields)
      end
    end

    def organization
      return @organization if @organization

      @organization = Organization.find(fields['idOrganization'])
    end
  end
end
