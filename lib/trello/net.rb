module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
      def execute(request)
        Trello.http_client.execute(request)
      end
    end
  end
end
