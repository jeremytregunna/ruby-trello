module Trello
  module TRestClient
    class TInternet
      class << self
        begin
          require 'rest-client'
        rescue LoadError
        end

        def execute(request)
          try_execute request
        end

        private

        def try_execute(request)
          begin
            if request
              result = execute_core request
              Response.new(200, {}, result.body)
            end
          rescue RestClient::Exception => e
            raise if !e.respond_to?(:http_code) || e.http_code.nil?
            Response.new(e.http_code, {}, e.http_body)
          end
        end

        def execute_core(request)
          RestClient.proxy = ENV['HTTP_PROXY'] if ENV['HTTP_PROXY']
          RestClient::Request.execute(
            method: request.verb,
            url: request.uri.to_s,
            headers: request.headers,
            payload: request.body,
            timeout: 10
          )
        end
      end
    end
  end
end
