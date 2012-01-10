# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

require 'trello/string'

module Trello
  class BasicData
    class << self
      def find(path, id)
        Client.get("/#{path}/#{id}").json_into(self)
      end
    end

    def ==(other)
      id == other.id
    end
  end
end