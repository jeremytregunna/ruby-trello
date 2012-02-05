require 'addressable/uri'

module Trello
  class Client
    extend Authorization

    class << self
      def get(path, params = {})
        api_version = 1
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        uri.query_values = params unless params.empty?
        invoke_verb(:get, uri)
      end

      def post(path, body = {})
        api_version = 1
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        invoke_verb(:post, uri, body)
      end

      def put(path, body = {})
        api_version = 1
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        invoke_verb(:put, uri, body)
      end

      def invoke_verb(name, uri, body = nil)
        request = Request.new name, uri, {}, body
        response = TInternet.execute AuthPolicy.authorize(request)

        unless response.code.to_i == 200
          raise Error, response.body
          logger.error("[#{response.code.to_i} GET #{uri}]: #{response.body}")
        end

        response.body
      end
    end
  end
end
