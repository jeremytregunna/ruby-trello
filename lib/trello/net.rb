module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
      def execute(request)
        Trello.http_client.execute(request)
      end

      def multipart_file(file)
        Trello.http_client.multipart_file(file)
      end
    end
  end
end
