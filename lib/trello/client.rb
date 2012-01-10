# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

require 'addressable/uri'

module Trello
  class Client
    class EnterYourPublicKey < StandardError; end
    class EnterYourSecret < StandardError; end

    class << self
      attr_writer :public_key, :secret, :app_name

      def query(api_version, path, options = { :method => :get, :params => {} })
        uri = Addressable::URI.parse("https://api.trello.com/#{api_version}#{path}")
        uri.query_values = options[:params]

        access_token.send(options[:method], uri.to_s)
      end

      %w{get post put delete}.each do |http_method|
        send(:define_method, http_method) do |*args|
          path = args[0]
          params = args[1] || {}
          query(API_VERSION, path, :method => http_method, :params => params).read_body
        end
      end

      protected

      def consumer
        raise EnterYourPublicKey if @public_key.to_s.empty?
        raise EnterYourSecret if @secret.to_s.empty?

        OAuth::Consumer.new(@public_key, @secret, :site => 'https://trello.com',
                                                  :request_token_path => '/1/OAuthGetRequestToken',
                                                  :authorize_path => '/1/OAuthAuthorizeToken',
                                                  :access_token_path => '/1/OAuthGetAccessToken',
                                                  :http_method => :get)
      end

      def access_token
        return @access_token if @access_token

        @access_token = OAuth::AccessToken.new(consumer)
      end
    end
  end
end
