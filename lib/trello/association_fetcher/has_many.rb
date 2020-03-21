module Trello
  module AssociationFetcher
    class HasMany
      attr_reader :model, :name, :options

      def initialize(model, name, options)
        @model = model
        @name = name
        @options = options
      end

      def fetch(filter_params)
        opts      = options.dup
        resource  = opts.delete(:in)  || model.class.to_s.split("::").last.downcase.pluralize
        klass     = opts.delete(:via) || Trello.const_get(name.to_s.singularize.camelize)
        path      = opts.delete(:path) || name
        params = opts.merge(filter_params || {})

        resources = model.client.find_many(klass, "/#{resource}/#{model.id}/#{path}", params)
        MultiAssociation.new(model, resources).proxy
      end
    end
  end
end