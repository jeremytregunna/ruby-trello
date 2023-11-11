module Trello
  module TFaraday
    class TInternet
      class << self
        begin
          require 'faraday'
          require 'faraday/multipart'
          require 'mime/types'
        rescue LoadError
        end

        def execute(request)
          try_execute request
        end

        def multipart_file(file)
          Faraday::Multipart::FilePart.new(
            file,
            content_type(file),
            filename(file)
          )
        end

        private

        def try_execute(request)
          begin
            if request
              result = execute_core request
              Response.new(200, {}, result.body)
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
            faraday.request :multipart
            faraday.request :json
          end

          conn.send(request.verb) do |req|
            req.body = request.body
          end
        end

        def content_type(file)
          return file.content_type if file.respond_to?(:content_type)

          mime = MIME::Types.type_for file.path
          if mime.empty?
            'text/plain'
          else
            mime[0].content_type
          end
        end

        def filename(file)
          if file.respond_to?(:original_filename)
            file.original_filename
          else
            File.basename(file.path)
          end
        end

      end
    end
  end
end
