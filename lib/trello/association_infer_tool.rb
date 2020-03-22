module Trello
  class AssociationInferTool
    class << self
      def infer_restful_resource_on_class(klass)
        klass.to_s.split('::').last.downcase.pluralize
      end

      def infer_class_on_name(name)
        Trello.const_get(name.to_s.singularize.camelize)
      end
    end
  end
end
