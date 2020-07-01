module Trello
  class Schema
    module Serializer
      class Default
        class << self
          def serialize(value)
            value
          end

          def deserialize(value)
            value
          end
        end
      end
    end
  end
end
