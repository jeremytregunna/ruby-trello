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
  class CustomField < BasicData
    register_attributes :id, :model_id, :model_type, :field_group, :name, :pos, :type
    validates_presence_of :id, :model_id, :model_type, :name, :type, :pos

    SYMBOL_TO_STRING = {
      id:          'id',
      name:        'name',
      model_id:    'idModel',
      model_type:  'modelType',
      field_group: 'fieldGroup',
      type:        'type',
      pos:         'pos'
    }

    class << self
      # Find a custom field by its id.
      def find(id, params = {})
        client.find('customFields', id, params)
      end

      # Create a new custom field and save it on Trello.
      def create(options)
        client.create('customFields',
          'name'       => options[:name],
          'idModel'    => options[:model_id],
          'modelType'  => options[:model_type],
          'fieldGroup' => options[:field_group],
          'type'       => options[:type],
          'pos'        => options[:pos]
        )
      end
    end

    # References Board where this custom field is located
    # Currently, model_type will always be "board" at the customFields endpoint
    one :board, path: :boards, using: :model_id

    # If type == 'list'
    many :custom_field_options, path: 'options'

    def update_fields(fields)
      attributes[:id]          = fields[SYMBOL_TO_STRING[:id]] || fields[:id] || attributes[:id]
      attributes[:name]        = fields[SYMBOL_TO_STRING[:name]] || fields[:name] || attributes[:name]
      attributes[:model_id]    = fields[SYMBOL_TO_STRING[:model_id]] || fields[:model_id] || attributes[:model_id]
      attributes[:model_type]  = fields[SYMBOL_TO_STRING[:model_type]] || fields[:model_type] || attributes[:model_type]
      attributes[:field_group] = fields[SYMBOL_TO_STRING[:field_group]] || fields[:field_group] || attributes[:field_group]
      attributes[:type]        = fields[SYMBOL_TO_STRING[:type]] || fields[:type] || attributes[:type]
      attributes[:pos]         = fields[SYMBOL_TO_STRING[:pos]] || fields[:pos] || attributes[:pos]
      self
    end

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      from_response client.post("/customFields", {
        name:       name,
        idModel:    model_id,
        modelType:  model_type,
        type:       type,
        pos:        pos,
        fieldGroup: field_group
      })
    end

    # Update an existing custom field.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.try(:clear)
      changes_applied if respond_to?(:changes_applied)

      client.put("/customFields/#{id}", payload)
    end

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
