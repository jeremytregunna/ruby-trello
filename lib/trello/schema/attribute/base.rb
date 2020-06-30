module Trello
  class Schema
    module Attribute
      class Base

        attr_reader :name, :options, :serializer

        def initialize(name:, options:, serializer:)
          @name = name.to_sym
          @options = options || {}
          @serializer = serializer
        end

        def build_attributes(params, attributes)
          raise 'Need override'
        end

        def build_payload_for_create(attributes, payload)
          raise 'Need override'
        end

        def build_payload_for_update(attributes, payload)
          raise 'Need override'
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
