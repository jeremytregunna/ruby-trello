module Trello
  class RegisterAttributes
    class << self
      def execute(model_klass, names, readonly_names)
        names ||= []
        readonly_names ||= []

        model_klass.class_eval do
          define_method :attributes do
            @__attributes ||= names.reduce({}) { |hash, k| hash.merge(k.to_sym => nil) }
          end

          names.each do |key|
            define_method(:"#{key}") { @__attributes[key] }

            unless readonly_names.include?(key.to_sym)
              define_method :"#{key}=" do |val|
                send(:"#{key}_will_change!") unless val == @__attributes[key]
                @__attributes[key] = val
              end
            end
          end

          define_attribute_methods names
        end
      end
    end
  end
end