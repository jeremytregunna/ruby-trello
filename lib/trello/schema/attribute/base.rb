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

        def build_pending_update_attributes(params, attributes)
          params = params.with_indifferent_access

          return attributes unless params.key?(remote_key) || params.key?(name)

          build_attributes(params, attributes)
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

        def primary_key?
          return false unless options.key?(:primary_key)

          options[:primary_key] 
        end

        def for_action?(action)
          case action
          when :create
            create_only? || (!update_only? && !readonly? && !primary_key?)
          when :update
            update_only? || primary_key? || (!create_only? && !readonly?)
          else
            false
          end
        end

        def remote_key
          (options[:remote_key] || name).to_s
        end

        def default
          return nil unless options.key?(:default)

          options[:default]
        end

        def register(model_klass)
          AttributeRegistration.register(model_klass, self)
        end
      end
    end
  end
end
