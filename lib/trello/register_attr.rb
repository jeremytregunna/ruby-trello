module Trello
  class RegisterAttr
    class << self
      def execute(model_klass, name, options = {})
        new(model_klass, name, options).execute
      end
    end

    attr_reader :model_klass, :name, :options

    def initialize(model_klass, name, options)
      @model_klass = model_klass
      @name = name
      @options = options || {}
    end

    def execute
      define_getter
      define_setter
    end

    private

    def define_getter
      attribute_name = name

      model_klass.class_eval do
        define_method(attribute_name) { @__attributes[attribute_name] }
      end
    end

    def define_setter
      return if readonly?

      attribute_name = name

      model_klass.class_eval do
        define_method("#{attribute_name}=") do |value|
          send("#{attribute_name}_will_change!") if value != @__attributes[attribute_name]
          @__attributes[attribute_name] = value
        end
      end
    end

    def readonly?
      options[:readonly]
    end
  end
end