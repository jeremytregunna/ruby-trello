module Trello
  class Configuration
    CONFIGURABLE_ATTRIBUTES = [
      :developer_public_key,
      :member_token,
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :callback,
      :return_url
    ]

    attr_accessor *CONFIGURABLE_ATTRIBUTES

    def self.configurable_attributes
      CONFIGURABLE_ATTRIBUTES
    end

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def attributes=(attrs = {})
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def credentials
      case
      when oauth?
        oauth_credentials
      when basic?
        basic_credentials
      else
        {}
      end
    end

    def oauth?
      consumer_key && consumer_secret
    end

    def basic?
      developer_public_key && member_token
    end

    private

    def oauth_credentials
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :oauth_token => oauth_token,
        :oauth_token_secret => oauth_token_secret,
        :return_url => return_url,
        :callback => callback,
      }.delete_if { |key, value| value.nil? }
    end

    def basic_credentials
      {
        :developer_public_key => developer_public_key,
        :member_token => member_token
      }
    end

  end
end
