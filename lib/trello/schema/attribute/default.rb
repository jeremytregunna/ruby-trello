module Trello
  class Schema
    module Attribute
      class Default

        attr_reader :name, :options, :serializer

        def initialize(name:, options:, serializer:)
          @name = name.to_sym
          @options = options || {}
          @serializer = serializer
        end

        def build_attributes(params, attributes)
          attributes ||= {}
          value = params[remote_key] || params[name]
          attributes[name] = serializer.deserialize(value)
          attributes
        end

        def build_payload(attributes, payload)
          payload ||= {}
          value = attributes[name] || params[name.to_s]
          payload[remote_key] = serializer.serialize(value)
          payload
        end

        def readonly?
          options[:readonly] == true
        end

        def update_only?
          options[:update_only] == true
        end

        def create_only?
          options[:create_only] == true
        end

        def remote_key
          options[:remote_key] || name.to_s
        end

      end
    end
  end
end
