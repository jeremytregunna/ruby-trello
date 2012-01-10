# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class ItemState < BasicData
    attr_reader :id, :state, :item_id

    class << self
      def find(nothing)
        raise 'This operation does not make sense'
      end
    end

    def initialize(fields = {})
      @id      = fields['id']
      @state   = fields['state']
      @item_id = fields['idItem']
    end

    # Links to other data structures

    def item
      # Nothing here for now. I will implement it myself later, but Trello really
      # needs an API to query check items in my estimation. Otherwise, the "idCheckItem"
      # key serves no good purpose. I'd have to know what checklist this state belongs
      # to, and then query all of its items, comparing the ID as I go. O(n) at the best
      # of times. If I don't have the checklist, then we're O(m*n^2). Horrible.
    end
  end
end