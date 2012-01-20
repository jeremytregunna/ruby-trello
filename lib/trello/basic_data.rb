require 'trello/string'

module Trello
  class BasicData
    attr_reader :id

    class << self
      def find(path, id)
        Client.get("/#{path}/#{id}").json_into(self)
      end
    end

    def initialize(fields = {})
      update_fields(fields)
    end

    def update_fields(fields)
      raise NotImplementedError, "#{self.class} does not implement update_fields."
    end

    # Refresh the contents of our object.
    def refresh!
      self.class.find(id)
    end

    # Two objects are equal if their _id_ methods are equal.
    def ==(other)
      id == other.id
    end
  end
end
