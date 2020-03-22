module Trello
  module AssociationFetcher
    class HasMany
      autoload :Params, 'trello/association_fetcher/has_many/params'
      autoload :Fetch, 'trello/association_fetcher/has_many/fetch'

      attr_reader :model, :name, :options

      def initialize(model, name, options)
        @model = model
        @name = name
        @options = options
      end

      def fetch(filter_params)
        params = Params.new(
          association_owner: model,
          association_name: name,
          default_filter: options,
          filter: filter_params 
        )
        Fetch.execute(params)
      end
    end
  end
end