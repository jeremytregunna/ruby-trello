module Trello
  # A file or url that is linked to a Trello card
  #
  # @!attribute id
  #   @return [String]
  # @!attribute plugin_id
  #   @return [String]
  # @!attribute scope
  #   @return [String]
  # @!attribute model_id
  #   @return [String]
  # @!attribute value
  #   @return [String]
  # @!attribute access
  #   @return [String]
  class PluginDatum < BasicData

    schema do
      attribute :id, readonly: true
      attribute :plugin_id, readonly: true, remote_key: 'idPlugin'
      attribute :scope, readonly: true
      attribute :model_id, readonly: true, remote_key: 'idModel'
      attribute :value, readonly: true, remote_key: 'value'
      attribute :access, readonly: true
    end

  end

end
