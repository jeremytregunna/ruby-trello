# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Item < BasicData
    class << self
      def find(nothing)
        raise 'This operation does not make sense'
      end
    end

    # Fields

    def id
      fields['id']
    end

    def name
      fields['name']
    end

    def type
      fields['type']
    end
  end
end