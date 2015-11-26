module Trello
  module JsonUtils
    extend ActiveSupport::Concern

    def from_response(*args)
      update_fields parse_json(*args)
    end

    def parse_json(*args)
      self.class.parse_json(*args)
    end

    module ClassMethods
      def from_response(data)
        from_json(parse_json(data))
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

      def parse_json(string, encoding = 'UTF-8')
        JSON.parse(string.force_encoding(encoding))
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
