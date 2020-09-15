module Trello
  class Schema
    module Attribute
      class CustomFieldDisplay < Base

        def build_attributes(params, attributes)
          attrs = attributes.with_indifferent_access
          params = params.with_indifferent_access

          value = if params.key?(:display)
                    params[:display][remote_key]
                  else
                    params[name]
                  end

          attrs[name] = serializer.deserialize(value, default)
          attrs
        end

        def build_payload_for_create(attributes, payload)
          payload ||= {}
          return payload unless for_action?(:create)
          return payload unless attributes.key?(name)

          value = attributes[name]
          return payload if value.nil?

          payload["display_#{remote_key}"] = serializer.serialize(value)
          payload
        end

        def build_payload_for_update(attributes, payload)
          payload ||= {}
          return payload unless for_action?(:update)
          return payload unless attributes.key?(name)

          value = attributes[name]
          payload["display/#{remote_key}"] = serializer.serialize(value)
          payload
        end

      end
    end
  end
end
