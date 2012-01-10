# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Item < BasicData
    attr_reader :id, :name, :type

    class << self
      def find(nothing)
        raise 'This operation does not make sense'
      end
    end

    def initialize(fields = {})
      @id   = fields['id']
      @name = fields['name']
      @type = fields['type']
    end
  end
end