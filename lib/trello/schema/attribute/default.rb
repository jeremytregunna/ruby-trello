module Trello
  class Schema
    module Attribute
      class Default < Base

        def build_attributes(params, attributes)
          attributes ||= {}
          value = params[remote_key] || params[name]
          attributes[name] = serializer.deserialize(value, default)
          attributes
        end

        def build_payload_for_create(attributes, payload)
          payload ||= {}
          return payload unless for_action?(:create)
          return payload unless attributes.key?(name)

          value = attributes[name] || attributes[name.to_s]
          return payload if value.nil?

          payload[remote_key] = serializer.serialize(value)
          payload
        end

        def build_payload_for_update(attributes, payload)
          payload ||= {}
          return payload unless for_action?(:update)
          return payload unless attributes.key?(name)

          value = attributes[name] || params[name.to_s]
          payload[remote_key] = serializer.serialize(value)
          payload
        end

      end
    end
  end
end
