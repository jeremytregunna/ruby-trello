# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Checklist < BasicData
    class << self
      def find(id)
        super(:checklists, id)
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

    def closed?
      fields['closed']
    end

    def url
      fields['url']
    end

    # Links to other data structures

    def items
      fields['checkItems'].map do |item_fields|
        Item.new(item_fields)
      end
    end

    def board
      Board.find(fields['idBoard'])
    end

    def list
      List.find(fields['idList'])
    end

    def members
      fields['idMembers'].map do |member_id|
        Member.find(member_id)
      end
    end
  end
end