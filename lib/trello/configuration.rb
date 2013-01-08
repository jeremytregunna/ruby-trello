module Trello
  class Configuration
    attr_accessor :auth_policy
    attr_accessor :developer_public_key, :member_token
    attr_accessor :consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret

    def initialize(attrs = {})
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def credentials
      case auth_policy
      when :oauth
        oauth_credentials
      when :basic
        basic_credentials
      else
        {}
      end
    end

    private

    def oauth_credentials
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :oauth_token => oauth_token,
        :oauth_token_secret => oauth_token_secret,
      }
    end

    def basic_credentials
      {
        :developer_public_key => developer_public_key,
        :member_token => member_token
      }
    end

  end
end
