module Trello
  module Utils
    def from_json(json)
      case json
      when Array
        json.map { |element| from_json(element) }
      when Hash
        action = self.kind_of?(Class) ? :new : :update_fields
        self.send(action, json)
      else
        json
      end
    end

    def parse_json(string)
      data = JSON.parse(self.force_encoding(encoding))
      from_json(data)
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
