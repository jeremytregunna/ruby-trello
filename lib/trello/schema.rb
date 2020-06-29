module Trello
  class Schema
    attr_reader :attrs

    def initialize
      @attrs = {}
    end

    def attribute(name, options={})
      @attrs[name.to_sym] = Attribute.new(name, options)
      self
    end
  end
end