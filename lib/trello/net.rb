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
            response_body = if [200, 201].include? result.status
              result
            else
              result.body
            end
            Response.new(result.status, {}, response_body)
          end
        rescue Faraday::Error => e
          raise if !e.respond_to?(:status) || e.status.nil?
          Response.new(e.status, {}, e.body)
        end
      end

      def execute_core(request)
        conn = Faraday.new(
          request.uri.to_s,
          headers: request.headers,
          proxy: ENV['HTTP_PROXY'],
          request: { timeout: 10 }
        )

        conn.send(request.verb) do |req|
          req.body = request.body
        end
      end
    end
  end
end
