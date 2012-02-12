module Trello
  Request = Struct.new "Request", :verb, :uri, :headers, :body
  Response = Struct.new "Response", :code, :headers, :body

  class TInternet
    class << self
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
        rescue Exception => e
          Response.new(e.http_code, {}, e.http_body)
        end
      end

      def execute_core(request)
        require "rest_client"
        
        RestClient::Request.execute(
          :method => request.verb, 
          :url => request.uri.to_s, 
          :headers => request.headers, 
          :payload => request.body, 
          :timeout => 10
        )
      end
    end
  end
end
