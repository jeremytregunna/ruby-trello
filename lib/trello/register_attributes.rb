module Trello
  class RegisterAttributes
    class << self
      def execute(model_klass, names, readonly_names)
        names ||= []
        readonly_names ||= []
        assign_writable_attributes(model_klass, names, readonly_names)
        assign_readonly_attributes(model_klass, readonly_names)

        define_method_attributes(model_klass, names)
        define_getters(model_klass, names)
        define_setters(model_klass, names, readonly_names)
        track_attributes_changes(model_klass, names)
      end

      private

      def assign_writable_attributes(model_klass, names, readonly_names)
        writable_attributes = names - readonly_names
        model_klass.instance_variable_set(:@writable_attributes, writable_attributes)
      end

      def assign_readonly_attributes(model_klass, readonly_names)
        model_klass.instance_variable_set(:@readonly_attributes, readonly_names)
      end

      def define_method_attributes(model_klass, names)
        model_klass.class_eval do
          define_method :attributes do
            @__attributes ||= names.reduce({}) do |attrs, name|
              attrs.merge(name.to_sym => nil)
            end
          end
        end
      end

      def define_getters(model_klass, names)
        model_klass.class_eval do
          names.each do |key|
            define_method(key) { @__attributes[key] }
          end
        end
      end

      def define_setters(model_klass, names, readonly_names)
        model_klass.class_eval do
          names.each do |key|
            next if readonly_names.include?(key.to_sym)

            define_method("#{key}=") do |value|
              send("#{key}_will_change!") if value != @__attributes[key]
              @__attributes[key] = value
            end
          end
        end
      end

      def track_attributes_changes(model_klass, names)
        model_klass.class_eval do
          define_attribute_methods(names)
        end
      end
    end
  end
end
