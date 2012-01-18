require 'addressable/uri'

module Trello
  AuthPolicy = Class.new

  Request = Struct.new "Request", :uri, :headers, :body

  TInternet = Class.new
 
  class Client
    class EnterYourPublicKey < StandardError; end
    class EnterYourSecret < StandardError; end

    class << self
      def get(api_version, path, params = {})
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
