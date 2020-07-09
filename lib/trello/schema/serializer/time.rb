module Trello
  class Schema
    module Serializer
      class Time
        class << self
          def serialize(time)
            return nil unless time.respond_to?(:iso8601)

            time.strftime('%FT%T.%LZ')
          end

          def deserialize(time, default)
            if time.is_a?(String)
              ::Time.iso8601(time) rescue default
            elsif time.respond_to?(:to_time)
              time.to_time
            else
              default
            end
          end
        end
      end
    end
  end
end
