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
    autoload :AttributeRegistration, 'trello/schema/attribute_registration'

    attr_reader :attrs

    def initialize
      @attrs = ActiveSupport::HashWithIndifferentAccess.new
    end

    def attribute(name, options={})
      @attrs[name] = AttributeBuilder.build(name, options)
      self
    end
  end
end