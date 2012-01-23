module Trello
  Request = Struct.new "Request", :uri, :headers, :body

  class TInternet
    class << self
      def get(request)
        require "rest_client"
        RestClient.get request.uri.to_s, request.headers
      end
    end
  end
end
