module Trello
  class Schema
    module Serializer
      class Webhooks
        class << self
          def serialize(webhooks)
            webhooks ||= []

            webhooks.map(&:id)
          end

          def deserialize(webhooks, default)
            return default unless webhooks

            webhooks.map do |webhook|
              next webhook if webhook.is_a?(Trello::Webhook)

              Trello::Webhook.new(webhook)
            end
          end
        end
      end
    end
  end
end
