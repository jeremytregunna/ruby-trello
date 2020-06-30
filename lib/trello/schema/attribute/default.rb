module Trello
  class Schema
    module Attribute
      class Default < Base

        def build_attributes(params, attributes)
          attributes ||= {}
          value = params[remote_key] || params[name]
          attributes[name] = serializer.deserialize(value)
          attributes
        end

        def build_payload_for_create(attributes, payload)
          build_payload(attributes, payload)
        end

        def build_payload_for_update(attributes, payload)
          build_payload(attributes, payload)
        end

        private

        def build_payload(attributes, payload)
          payload ||= {}
          value = attributes[name] || params[name.to_s]
          payload[remote_key] = serializer.serialize(value)
          payload
        end

      end
    end
  end
end
