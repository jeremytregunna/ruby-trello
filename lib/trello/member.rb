# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Member < BasicData
    attr_reader :id, :full_name, :username, :gravatar_id, :bio, :url

    class << self
      def find(id_or_username)
        super(:members, id_or_username)
      end
    end

    def initialize(fields = {})
      @id          = fields['id']
      @full_name   = fields['fullName']
      @username    = fields['username']
      @gravatar_id = fields['gravatar']
      @bio         = fields['bio']
      @url         = fields['url']
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

    def to_hash
      {
        'id'       => id,
        'fullName' => full_name,
        'username' => username,
        'gravatar' => gravatar_id,
        'bio'      => bio,
        'url'      => url
      }
    end
  end
end
