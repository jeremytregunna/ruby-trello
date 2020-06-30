module Trello
  class Schema
    autoload :AttributeBuilder, 'trello/schema/attribute_builder'

    attr_reader :attrs

    def initialize
      @attrs = {}
    end

    def attribute(name, options={})
      @attrs[name.to_sym] = AttributeBuilder.build(name, options)
      self
    end
  end
end