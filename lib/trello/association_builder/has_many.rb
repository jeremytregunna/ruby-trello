module Trello
  module AssociationBuilder
    class HasMany
      class << self
        def build(model_klass, name, options)
          model_klass.class_eval do
            define_method(name) do |*args|
              has_many_fetcher = AssociationFetcher::HasMany.new(self, name, options)
              filter_params = args[0] || {}
              has_many_fetcher.fetch(filter_params)
            end
          end
        end
      end
    end
  end
end