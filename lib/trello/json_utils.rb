module Trello
  module JsonUtils
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods
    end

    module InstanceMethods
      def from_response(*args)
        initialize_fields parse_json(*args)
      end

      def parse_json(*args)
        self.class.parse_json(*args)
      end
    end

    module ClassMethods
      # Public - Decodes some JSON text in the receiver, and marshals it into a class specified
      # in _obj_.
      #
      # For instance:
      #
      #   class Stuff
      #     attr_reader :a, :b
      #     def initialize(values)
      #       @a = values['a']
      #       @b = values['b']
      #     end
      #   end
      #   thing = Stuff.from_response '{"a":42,"b":"foo"}'
      #   thing.a == 42
      #   thing.b == "foo"
      #
      def from_response(response, encoding = 'UTF-8')
        from_json(parse_json(response, encoding))
      end

      def from_json(json)
        case json
        when Array
          json.map { |element| from_json(element) }
        when Hash
          self.new(json)
        else
          json
        end
      end

      def parse_json(data, encoding = 'UTF-8')
        # Trello.http_client.parse_json(data, encoding)
        case data
        when Trello::Response
          JSON.parse(data.body.force_encoding(encoding))
        else
          JSON.parse(data.force_encoding(encoding))
        end
      rescue JSON::ParserError => json_error
        if json_error.message =~ /model not found/
          Trello.logger.error "Could not find that record."
          raise Trello::Error, "Request could not be found."
        elsif json_error.message =~ /A JSON text must at least contain two octets/
        else
          Trello.logger.error "Unknown error."
          raise
        end
      end
    end
  end
end
