require 'addressable/uri'

module Trello
  Request = Struct.new "Request", :uri, :headers, :body
  AuthPolicy = Class.new

  class BasicAuthPolicy
    class << self
      attr_accessor :developer_public_key, :member_token

      def authorize(request)
        the_uri = Addressable::URI.parse(request.uri)
        existing_values = the_uri.query_values.nil? ? {} : the_uri.query_values
        new_values = { :key => @developer_public_key, :token => @member_token }
        the_uri.query_values = new_values.merge existing_values

        Request.new the_uri, request.headers
      end
    end
  end

  class TInternet
    class << self
      def get(request)
        require "rest_client"
        RestClient.get request.uri.to_s, request.headers
      end
    end
  end
end

module Trello
  class Client
    class EnterYourPublicKey < StandardError; end
    class EnterYourSecret < StandardError; end

    class << self
      def get(path, params = {})
        api_version = 1
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        uri.query_values = params

        request = Request.new uri, {}

        response = TInternet.get AuthPolicy.authorize(request)

        raise Error, response.message if response.code.to_i != 200

        response
      end

      private

      def query(api_version, path, options = { :method => :get, :params => {} })
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        uri.query_values = options[:params]

        response = TInternet.send(options[:method], uri, {}, nil)

        raise Error, response.message if response.code.to_i != 200

        response
      end
    end
  end
end
