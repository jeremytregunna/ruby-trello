module Trello
  class Schema
    module Attribute
      autoload :Default, 'trello/schema/attribute/default'
    end

    module Serializer
      autoload :Default, 'trello/schema/serializer/default'
    end

    class AttributeBuilder
      class << self
        def build(name, options = {})
          new(name, options).build
        end
      end

      attr_reader :name, :options

      def initialize(name, options)
        @name = name
        @options = options
      end

      def build
        attribute_class.new(
          name: name,
          options: options,
          serializer: serializer
        )
      end

      private

      def attribute_class
        class_name = options.delete(:class_name)
        return Schema::Attribute::Default unless class_name

        "Trello::Schema::Attribute::#{class_name}".constantize
      end

      def serializer
        serializer_class_name = options.delete(:serializer)
        return Schema::Serializer::Default unless serializer_class_name

        "Trello::Schema::Serializer::#{serializer_class_name}".constantize
      end
    end
  end
end
