# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Action < BasicData
    attr_reader :id, :type, :data, :member_creator_id

    class << self
      def find(id)
        super(:actions, id)
      end
    end

    def initialize(fields = {})
      @id                = fields['id']
      @type              = fields['type']
      @data              = fields['data']
      @member_creator_id = fields['idMemberCreator']
    end

    # Links to other data structures

    def board
      return @board if @board
      @board = Client.get("/actions/#{id}/board").json_into(Board)
    end

    def card
      return @card if @card
      @card = Client.get("/actions/#{id}/card").json_into(Card)
    end

    def list
      return @list if @list
      @list = Client.get("/actions/#{id}/list").json_into(List)
    end

    def member_creator
      return @member_creator if @member_creator
      @member_creator = Member.find(member_creator_id)
    end
  end
end
