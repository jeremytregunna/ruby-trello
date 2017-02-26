module Trello
  # A file or url that is linked to a Trello card
  #
  # @!attribute id
  #   @return [String]
  # @!attribute idPlugin
  #   @return [String]
  # @!attribute scope
  #   @return [String]
  # @!attribute idModel
  #   @return [String]
  # @!attribute value
  #   @return [String]
  # @!attribute access
  #   @return [String]
    class PluginDatum < BasicData
    # Update the fields of a plugin.
    register_attributes :id, :idPlugin, :scope, :idModel, :value, :access


    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # an attachment.
    def update_fields(fields)
      attributes[:id]        = fields['id'] || attributes[:id]
      attributes[:idPlugin]  = fields['idPlugin'] || attributes[:idPlugin]
      attributes[:scope]     = fields['scope'] || attributes[:scope]
      attributes[:value]     = JSON.parse(fields['value']).presence if fields.has_key?('value')
      attributes[:idModel]   = fields['idModel'] || attributes[:idModel]
      attributes[:access]    = fields['access'] || attributes[:access]
      self
    end
  end

end
