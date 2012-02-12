require 'addressable/uri'

module Trello
  class Client
    extend Authorization

    class << self
      def get(path, params = {})
        uri = Addressable::URI.parse("https://api.trello.com/#{API_VERSION}#{path}")
        uri.query_values = params unless params.empty?
        invoke_verb(:get, uri)
      end

      def post(path, body = {})
        uri = Addressable::URI.parse("https://api.trello.com/#{API_VERSION}#{path}")
        invoke_verb(:post, uri, body)
      end

      def put(path, body = {})
        uri = Addressable::URI.parse("https://api.trello.com/#{API_VERSION}#{path}")
        invoke_verb(:put, uri, body)
      end

      def delete(path)
        uri = Addressable::URI.parse("https://api.trello.com/#{API_VERSION}#{path}")
        invoke_verb(:delete, uri)
      end

      def invoke_verb(name, uri, body = nil)
        request = Request.new name, uri, {}, body
        response = TInternet.execute AuthPolicy.authorize(request)

        return '' unless response

        if response.code.to_i == 401 && response.body =~ /expired token/
          Trello.logger.error("[401 #{name.to_s.upcase} #{uri}]: Your access token has expired.")
          raise InvalidAccessToken, response.body
        end

        unless [200, 201].include? response.code
          Trello.logger.error("[#{response.code} #{name.to_s.upcase} #{uri}]: #{response.body}")
          raise Error, response.body
        end

        response.body
      end
    end
  end
end
