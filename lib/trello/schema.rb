module Trello
  class Schema
    module Attribute
      autoload :Base, 'trello/schema/attribute/base'
      autoload :Default, 'trello/schema/attribute/default'
      autoload :BoardPref, 'trello/schema/attribute/board_pref'
    end

    module Serializer
      autoload :Default, 'trello/schema/serializer/default'
      autoload :Time, 'trello/schema/serializer/time'
    end

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