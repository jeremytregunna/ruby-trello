require 'trello/string'

module Trello
  class BasicData
    attr_reader :id

    class << self
      # Perform a query to retrieve some information at a specific path for a specific id.
      def find(path, id)
        Client.get("/#{path}/#{id}").json_into(self)
      end
    end

    # Two objects are equal if their _id_ methods are equal.
    def ==(other)
      id == other.id
    end
  end
end