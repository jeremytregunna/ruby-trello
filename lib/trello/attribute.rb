module Trello
  class Attribute

    module Core
      autoload :Default, 'trello/attribute/core/default'
    end

    module Serializer
      autoload :Default, 'trello/attribute/serializer/default'
    end

    attr_reader :name, :options

    def initialize(name, options={})
      @name = name.to_sym
      @options = options || {}
    end

    def build_attributes(params, attributes)
      core.build_attributes(
        params: params,
        attributes: attributes,
        serializer: serializer
      )
    end

    def build_payload(attributes, payload)
      core.build_payload(
        attributes: attributes,
        payload: payload,
        serializer: serializer
      )
    end

    def core
      return Core::Default unless options[:core]

      "Trello::Attribute::Core::#{options[:core]}".constantize
    end

    def serializer
      return Serializer::Default unless options[:serializer]

      "Trello::Attribute::Serializer::#{options[:serializer]}".constantize
    end

    def readonly?
      options[:readonly] == true
    end

    def update_only?
      options[:update_only] == true
    end

    def create_only?
      options[:create_only] == true
    end
  end
end