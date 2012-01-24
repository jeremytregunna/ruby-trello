module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
      def get(request)
        require "rest_client"

        begin
          result = RestClient.get request.uri.to_s, request.headers
          Response.new(200, {}, result)
        rescue Exception => e
          Response.new(e.http_code, {}, e.http_body)
        end
      end
    end
  end
end
