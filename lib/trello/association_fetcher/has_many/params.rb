module Trello
  module AssociationFetcher
    class HasMany
      class Params
      end
    end
  end
end
        # opts      = options.dup
        # resource  = opts.delete(:in)  || model.class.to_s.split("::").last.downcase.pluralize
        # klass     = opts.delete(:via) || Trello.const_get(name.to_s.singularize.camelize)
        # path      = opts.delete(:path) || name
        # params = opts.merge(filter_params || {})

        # resources = model.client.find_many(klass, "/#{resource}/#{model.id}/#{path}", params)
        # MultiAssociation.new(model, resources).proxy