require 'addressable/uri'

module Trello
  class Client
    class << self
      def get(path, params = {})
        api_version = 1

        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        uri.query_values = params unless params.empty?

        request = Request.new :get, uri, {}

        response = TInternet.get AuthPolicy.authorize(request)

        raise Error, response.body unless response.code.to_i == 200

        response.body
      end
    end
  end
end
