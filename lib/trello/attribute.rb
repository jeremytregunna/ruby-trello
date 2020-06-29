module Trello
  class Attribute
    attr_reader :name, :options

    def initialize(name, options={})
      @name = name
      @options = options || {}
    end
  end
end