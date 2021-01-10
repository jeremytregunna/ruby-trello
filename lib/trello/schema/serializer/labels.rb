module Trello
  class Schema
    module Serializer
      class Labels
        class << self
          def serialize(labels)
            labels.map(&:id)
          end

          def deserialize(labels, default)
            return default unless labels

            labels.map do |label|
              next label if label.is_a?(Trello::Label)

              Trello::Label.new(label)
            end
          end
        end
      end
    end
  end
end
