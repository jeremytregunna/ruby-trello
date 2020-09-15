module Trello
  # A Custom Field can be activated on a board. Values are stored at the card level.
  #
  # @!attribute id
  #   @return [String]
  # @!attribute model_id
  #   @return [String]
  # @!attribute model_type
  #   @return [String]
  # @!attribute field_group
  #   @return [String]
  # @!attribute name
  #   @return [String]
  # @!attribute pos
  #   @return [Float]
  # @!attribute type
  #   @return [String]
  # @!attribute options
  #   @return [Array<Hash>]
  class CustomField < BasicDataAlpha

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :field_group, readonly: true, remote_key: 'fieldGroup'

      # Writable
      attribute :name
      attribute :position, remote_key: 'pos'
      attribute :enable_display_on_card, remote_key: 'cardFront', class_name: 'CustomFieldDisplay'

      # Writable but for create only
      attribute :model_id, remote_key: 'idModel', create_only: true
      attribute :model_type, remote_key: 'modelType', create_only: true
      attribute :type, create_only: true
      attribute :checkbox_options, remote_key: 'options', create_only: true
    end

    validates_presence_of :id, :model_id, :model_type, :name, :type, :position

    class << self
      # Find a custom field by its id.
      def find(id, params = {})
        client.find('customFields', id, params)
      end
    end

    def collection_name
      'customFields'
    end

    # References Board where this custom field is located
    # Currently, model_type will always be "board" at the customFields endpoint
    one :board, path: :boards, using: :model_id

    # If type == 'list'
    many :custom_field_options, path: 'options'

    # Delete this custom field
    # Also deletes all associated values across all cards
    def delete
      client.delete("/customFields/#{id}")
    end

    # If type == 'list', create a new option and add to this Custom Field
    def create_new_option(value)
      payload = { value: value }
      client.post("/customFields/#{id}/options", payload)
    end

    # Will also clear it from individual cards that have this option selected
    def delete_option(option_id)
      client.delete("/customFields/#{id}/options/#{option_id}")
    end
  end
end
