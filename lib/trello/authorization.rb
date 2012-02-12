require 'securerandom'
require "oauth"

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

          Request.new request.verb, the_uri, request.headers
        end
      end
    end

    class Clock
      def self.timestamp; Time.now.to_i; end
    end

    class Nonce
      def self.next
        SecureRandom.hex()
      end
    end

    OAuthCredential = Struct.new "OAuthCredential", :key, :secret

    # Handles the OAuth connectivity to Trello.
    #
    # For 2-legged OAuth, do the following:
    #
    #    OAuthPolicy.consumer_credential = OAuthCredential.new "public_key", "secret"
    #    OAuthPolicy.token               = OAuthCredential.new "token_key", nil
    #
    # For 3-legged OAuth, do the following:
    #
    #    OAuthPolicy.consumer_credential = OAuthCredential.new "public_key", "secret"
    #    OAuthPolicy.return_url          = "http://your.site.com/path/to/receive/post"
    #    OAuthPolicy.callback            = Proc.new do |request_token|
    #      DB.save(request_token.key, request_token.secret)
    #      redirect_to request_token.authorize_url
    #    end
    #
    # Then, recreate the request token given the request token key and secret you saved earlier,
    # and the consumer, and pass that RequestToken instance the #get_access_token method, and
    # store that in OAuthPolicy.token as a OAuthCredential.
    class OAuthPolicy
      class << self
        attr_accessor :consumer_credential, :token, :return_url, :callback

        def authorize(request)
          unless consumer_credential
            Trello.logger.error "The consumer_credential has not been supplied."
            fail "The consumer_credential has not been supplied."
          end

          if token
            request.headers = {"Authorization" => get_auth_header(request.uri, :get)}
            request
          else
            consumer(:return_url => return_url, :callback_method => :postMessage)
            request_token = consumer.get_request_token
            callback.call request_token
            return nil
          end
        end

        private

        def consumer_params(params = {})
          {
            :scheme      => :header,
            :scope       => 'read,write,account',
            :http_method => :get,
            :request_token_path => "https://trello.com/1/OAuthGetRequestToken",
            :authorize_path     => "https://trello.com/1/OAuthAuthorizeToken",
            :access_token_path  => "https://trello.com/1/OAuthGetAccessToken"
          }.merge!(params)
        end

        def consumer(options = {})
          @consumer ||= OAuth::Consumer.new(
            consumer_credential.key,
            consumer_credential.secret,
            consumer_params(options)
          )
        end

        def get_auth_header(url, verb, options = {})
          self.token ||= OAuththCredential.new

          request = Net::HTTP::Get.new Addressable::URI.parse(url).to_s

          consumer.options[:signature_method] = 'HMAC-SHA1'
          consumer.options[:nonce]            = Nonce.next
          consumer.options[:timestamp] 	      = Clock.timestamp
          consumer.options[:uri]              = url
          
          consumer.sign!(request, OAuth::Token.new(token.key, token.secret))

          request['authorization']
        end
      end
    end
  end
end
