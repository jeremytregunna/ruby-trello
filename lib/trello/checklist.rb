# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Checklist < BasicData
    attr_reader :id, :name, :description, :closed, :url, :check_items, :board_id, :list_id, :member_ids

    class << self
      def find(id)
        super(:checklists, id)
      end
    end

    def initialize(fields = {})
      @id          = fields['id']
      @name        = fields['name']
      @description = fields['desc']
      @closed      = fields['closed']
      @url         = fields['url']
      @check_items = fields['checkItems']
      @board_id    = fields['idBoard']
      @member_ids  = fields['idMembers']
    end

    def closed?
      closed
    end

    # Links to other data structures

    def items
     return @items if @items

      @items = check_items.map do |item_fields|
        Item.new(item_fields)
      end
    end

    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    def list
      return @list if @list
      @list = List.find(list_id)
    end

    def members
      return @members if @members

      @members = member_ids.map do |member_id|
        Member.find(member_id)
      end
    end
  end
end
