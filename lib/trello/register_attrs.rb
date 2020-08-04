module Trello
  class RegisterAttrs
    class << self
      def execute(klass)
        new(klass).execute
      end
    end

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def execute
      attributes.each do |attribute|
        attribute.register(klass)
      end
    end

    private

    def attributes
      schema.attrs.values
    end

    def schema
      klass.schema
    end
  end
end