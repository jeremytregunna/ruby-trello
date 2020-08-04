module Trello
  class Schema
    class AttributeRegistration
      class << self
        def register(klass, attribute)
          new(klass, attribute).register
        end
      end

      attr_reader :klass, :attribute

      def initialize(klass, attribute)
        @klass = klass
        @attribute = attribute
      end

      def register
        define_getter
        define_setter
      end

      private

      def define_getter
        attribute_name = attribute.name

        klass.class_eval do
          define_method(attribute_name) { @__attributes[attribute_name] }
        end
      end

      def define_setter
        return if attribute.readonly?

        attribute_name = attribute.name

        klass.class_eval do
          define_method("#{attribute_name}=") do |value|
            send("#{attribute_name}_will_change!") if value != @__attributes[attribute_name]
            @__attributes[attribute_name] = value
          end
        end
      end

    end
  end
end