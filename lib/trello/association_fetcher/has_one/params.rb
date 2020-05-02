module Trello
  module AssociationFetcher
    class HasOne
      class Params
        attr_reader :association_owner

        def initialize(association_owner:, association_name:, association_options:)
          @association_owner = association_owner
          @association_name = association_name
          @association_options = association_options || {}
        end

        def association_class
          association_options[:via] || infer_class_on(association_name)
        end

        def association_restful_name
          association_options[:path]
        end

        def association_restful_id
          id_field = association_options[:using] || :id
          association_owner.send(id_field)
        end

        private

        attr_reader :association_name, :association_options

        def infer_class_on(name)
          AssociationInferTool.infer_class_on_name(name)
        end
      end
    end
  end
end