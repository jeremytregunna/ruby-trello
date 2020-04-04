module Trello
  module AssociationFetcher
    class HasOne
      autoload :Params, 'trello/association_fetcher/has_one/params'
      autoload :Fetch, 'trello/association_fetcher/has_one/fetch'

      attr_reader :model, :name, :options

      def initialize(model, name, options)
        @model = model
        @name = name
        @options = options
      end

      def fetch
        params = Params.new(
          association_owner: model,
          association_name: name,
          association_options: options
        )
        Fetch.execute(params)
      end
    end
  end
end