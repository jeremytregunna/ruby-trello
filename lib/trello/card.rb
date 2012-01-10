# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Card < BasicData
    class << self
      def find(id)
        super(:cards, id)
      end

      def create(details = {})
        
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
      @actions = Client.get("/cards/#{id}/actions").json_into(Action)
    end

    def board
      return @board if @board
      @board = Board.find(fields['idBoard'])
    end

    def checklists
      return @checklists if @checklists
      @checklists = Client.get("/cards/#{id}/checklists").json_into(Checklist)
    end

    def list
      return @list if @list
      @list = List.find(fields['idList'])
    end

    def members
      return @members if @members
      @members = fields['idMembers'].map do |member_id|
        Client.get("/members/#{member_id}").json_into(Member)
      end
    end

    # Add a comment
    def add_comment(text)
      Client.put("/cards/#{id}/actions/comments", :text => text)
    end
  end
end
