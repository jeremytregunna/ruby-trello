module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
      require "faraday"

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
        rescue Faraday::Error => e
          raise if !e.respond_to?(:response) || e.response.nil? || e.response[:status].nil?
          Response.new(e.response[:status], {}, e.response[:body])
        end
      end

      def execute_core(request)
        conn = Faraday.new(
          request.uri.to_s,
          headers: request.headers,
          proxy: ENV['HTTP_PROXY'],
          request: { timeout: 10 }
        ) do |faraday|
          faraday.response :raise_error
          faraday.request :json
        end

        conn.send(request.verb) do |req|
          req.body = request.body
        end
      end
    end
  end
end
