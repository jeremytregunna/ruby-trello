module Trello
  module AssociationFetcher
    class HasMany
      class Fetch
        class << self
          def execute(params)
            new(params).execute
          end
        end

        attr_reader :params

        def initialize(params)
          @params = params
        end

        def execute
          resources = client.find_many(association_class, path, filter_params)

          MultiAssociation.new(association_owner, resources).proxy
        end

        private

        def client
          association_owner.client
        end

        def association_class
          params.association_class
        end

        def path
          params.fetch_path
        end

        def filter_params
          params.filter_params
        end

        def association_owner
          params.association_owner
        end
      end
    end
  end
end