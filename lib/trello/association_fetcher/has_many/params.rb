module Trello
  module AssociationFetcher
    class HasMany
      class Params
        attr_reader :association_owner

        def initialize(association_owner:, association_name:, association_options:, filter:)
          @association_owner = association_owner
          @association_name = association_name
          @association_options = association_options || {}
          @filter = filter || {}
        end

        def association_class
          association_options[:via] || infer_class_on(association_name)
        end

        def fetch_path
          "/#{parent_restful_resource}/#{parent_restful_resource_id}/#{target_restful_resource}"
        end

        def filter_params
          default_filter.merge(filter)
        end

        private

        attr_reader :association_name, :association_options, :filter

        def default_filter
          association_options.reject { |k, _| %w[via in path].include?(k.to_s) }
        end

        def parent_restful_resource
          association_options[:in] || infer_restful_resource_on(association_owner.class)
        end

        def parent_restful_resource_id
          association_owner.id
        end

        def target_restful_resource
          association_options[:path] || association_name
        end

        def infer_restful_resource_on(klass)
          AssociationInferTool.infer_restful_resource_on_class(klass)
        end

        def infer_class_on(name)
          AssociationInferTool.infer_class_on_name(name)
        end
      end
    end
  end
end
