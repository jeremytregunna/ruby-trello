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

    def actions
      return @actions if @actions
      @actions = Client.get("/members/#{username}/actions").json_into(Action)
    end

    def boards
      return @boards if @boards
      @boards = Client.get("/members/#{username}/boards/all").json_into(Board)
    end

    def cards
      return @cards if @cards
      @cards = Client.get("/members/#{username}/cards/all").json_into(Card)
    end

    def organizations
      return @organizations if @organizations
      @organizations = Client.get("/members/#{username}/organizations/all").json_into(Organization)
    end
  end
end
