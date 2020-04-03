module Trello
  module AssociationFetcher
    class HasOne
      attr_reader :model, :name, :options

      def initialize(model, name, options)
        @model = model
        @name = name
        @options = options
      end

      def fetch
        opts = options.dup
        klass   = opts.delete(:via) || Trello.const_get(name.to_s.camelize)
        ident   = opts.delete(:using) || :id
        path    = opts.delete(:path)

        if path
          model.client.find(path, model.send(ident))
        else
          klass.find(model.send(ident))
        end
      end
    end
  end
end