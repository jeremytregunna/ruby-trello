# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class BasicData
    attr_reader :fields

    class << self
      def find(path, id)
        response = Client.query("/1/#{path}/#{id}")
        new(JSON.parse(response.read_body))
      end
    end

    # Fields
    def initialize(fields = {})
      @fields = fields
    end

    def ==(other)
      @fields == other.fields
    end
  end
end