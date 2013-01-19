require 'addressable/uri'

module Trello
  class Client
    include Authorization

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

    def find(path, id)
      object_from_response class_from_path(path), get("/#{path.to_s.pluralize}/#{id}")
    end

    def object_from_response(klass, response)
      response.json_into(klass).tap { |data| data.client = self }
    end

    def create(path, options)
      class_from_path(path).new(options).tap { |data| data.client = self }.save
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def auth_policy
      @auth_policy ||= auth_policy_class.new(configuration.credentials)
    end

    private

    def invoke_verb(name, uri, body = nil)
      request = Request.new name, uri, {}, body
      response = TInternet.execute auth_policy.authorize(request)

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

    def auth_policy_class
      if configuration.oauth?
        OAuthPolicy
      elsif configuration.basic?
        BasicAuthPolicy
      else
        AuthPolicy
      end
    end

    def class_from_path(path)
      Trello.const_get(path.to_s.singularize.camelize)
    end
  end
end
