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

    def actions
      return @actions if @actions
      @actions = Client.get("/organizations/#{id}/actions").json_into(Action)
    end

    def boards
      return @boards if @boards
      @boards = Client.get("/organizations/#{id}/boards/all").json_into(Board)
    end

    def members
      return @members if @members
      @members = Client.get("/organizations/#{id}/members/all").json_into(Member)
    end
  end
end
