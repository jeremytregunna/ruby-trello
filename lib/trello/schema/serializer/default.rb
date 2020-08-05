module Trello
  class Schema
    module Serializer
      class Default
        class << self
          def serialize(value)
            value
          end

          def deserialize(value, default)
            value == nil ? default : value
          end
        end
      end
    end
  end
end
