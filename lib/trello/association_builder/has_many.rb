module Trello
  module AssociationBuilder
    class HasMany
      class << self
        def build(model_klass, name, options)
          new(model_klass, name, options).build
        end
      end

      attr_reader :model_klass, :name, :options

      def initialize(model_klass, name, options)
        @model_klass = model_klass
        @name = name
        @options = options
      end

      def build
        opts = options
        model_klass = self.model_klass
        name = self.name

        model_klass.define_method(:"#{name}") do |*args|
          options   = opts.dup
          resource  = options.delete(:in)  || model_klass.to_s.split("::").last.downcase.pluralize
          klass     = options.delete(:via) || Trello.const_get(name.to_s.singularize.camelize)
          path      = options.delete(:path) || name
          params    = options.merge(args[0] || {})

          resources = client.find_many(klass, "/#{resource}/#{id}/#{path}", params)
          MultiAssociation.new(self, resources).proxy
        end
      end
    end
  end
end