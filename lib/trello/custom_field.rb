module Trello
  # A Custom Field that can be activated on a board.
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
        client.find(:custom_field, id, params)
      end

      # Create a new custom field and save it on Trello.
      def create(options)
        client.create(:custom_field,
          'name'       => options[:name],
          'idModel'    => options[:model_id],
          'modelType'  => options[:model_type],
          'fieldGroup' => options[:field_group],
          'type'       => options[:type],
          'pos'        => options[:pos]
        )
      end
    end

    def update_fields(fields)
      attributes[:id]          = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      attributes[:name]        = fields[SYMBOL_TO_STRING[:name]] || attributes[:name]
      attributes[:model_id]    = fields[SYMBOL_TO_STRING[:model_id]] || attributes[:model_id]
      attributes[:model_type]  = fields[SYMBOL_TO_STRING[:model_type]] || attributes[:model_type]
      attributes[:field_group] = fields[SYMBOL_TO_STRING[:field_group]] || attributes[:field_group]
      attributes[:type]        = fields[SYMBOL_TO_STRING[:type]] || attributes[:type]
      attributes[:pos]         = fields[SYMBOL_TO_STRING[:pos]] || attributes[:pos]
      self
    end

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      from_response client.post("/customFields", {
        name:       name,
        color:      color,
        idModel:    model_id,
        modelType:  model_type,
        type:       type,
        pos:        pos,
        fieldGroup: field_group
      })
    end

    # Delete this custom field
    # Also deletes all associated values across all cards
    def delete
      client.delete("/customFields/#{id}")
    end
  end
end