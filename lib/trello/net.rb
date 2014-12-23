module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
      require "rest_client"

      def execute(request)
        try_execute request
      end

      private

      def try_execute(request)
        begin
          if request
            result = execute_core request
            Response.new(200, {}, result)
          end
        rescue RestClient::Exception => e
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
