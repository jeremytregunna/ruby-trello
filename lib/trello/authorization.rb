module Trello
  Request = Struct.new "Request", :uri, :headers, :body

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
  module Authorization

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

    class Clock
      def self.timestamp; Time.now.to_i; end
    end

    class Nonce
      def self.next; "xxx"; end
    end

    OAuthCredential = Struct.new "OAuthCredential", :key, :secret

    class OAuthPolicy
      class << self
        attr_accessor :consumer_credential

        def authorize(request)
          request.headers = {"Authorization" => get_auth_header(request.uri, :get, consumer_credential)}
          request
        end

        private

        def get_auth_header(url, verb, consumer_credential)
          require "oauth"

          consumer = OAuth::Consumer.new(
	    consumer_credential.key,
	    consumer_credential.secret,
            {
    	      :scheme	   => :header,
              :http_method => verb
            }
          )

          request = Net::HTTP::Get.new Addressable::URI.parse(url).to_s

          consumer.options[:signature_method] = 'HMAC-SHA1'
          consumer.options[:nonce]            = Nonce.next
          consumer.options[:timestamp] 	      = Clock.timestamp
          consumer.options[:uri]              = url
          
          consumer.sign!(request)
          
          request['authorization']
        end
      end
    end
  end
end
