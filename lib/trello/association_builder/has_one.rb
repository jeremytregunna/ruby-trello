module Trello
  module AssociationBuilder
    class HasOne
      class << self
        def build(model_klass, name, options)
          model_klass.class_eval do
            define_method(name) do |*args|
              has_one_fetcher = AssociationFetcher::HasOne.new(self, name, options)
              has_one_fetcher.fetch
            end
          end
        end
      end
    end
  end
end