module Trello
  module AssociationFetcher
    class HasOne
      class Fetch
        class << self
          def execute(params)
            new(params).execute
          end
        end

        def initialize(params)
          @params = params
        end

        def execute
          if association_restful_name
            client.find(association_restful_name, association_restful_id)
          else
            association_class.find(association_restful_id)
          end
        end

        private

        attr_reader :params

        def client
          association_owner.client
        end

        def association_owner
          params.association_owner
        end

        def association_restful_name
          params.association_restful_name
        end

        def association_restful_id
          params.association_restful_id
        end

        def association_class
          params.association_class
        end
      end
    end
  end
end