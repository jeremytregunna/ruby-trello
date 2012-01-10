# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Board < BasicData
    attr_reader :id, :name, :description, :closed, :url, :organization_id

    class << self
      def find(id)
        super(:boards, id)
      end
    end

    def initialize(fields = {})
      @id              = fields['id']
      @name            = fields['name']
      @description     = fields['desc']
      @closed          = fields['closed']
      @url             = fields['url']
      @organization_id = fields['idOrganization']
    end

    def closed?
      closed
    end

    # Links to other data structures

    def actions
      return @actions if @actions
      @actions = Client.get("/boards/#{id}/actions").json_into(Action)
    end

    def cards
      return @cards if @cards
      @cards = Client.get("/boards/#{id}/cards/all").json_into(Card)
    end

    def lists
      return @lists if @lists
      @lists = Client.get("/boards/#{id}/lists/all").json_into(List)
    end

    def members
      return @members if @members
      @members = Client.get("/boards/#{id}/members/all").json_into(Member)
    end

    def organization
      return @organization if @organization
      @organization = Organization.find(organization_id)
    end
  end
end
