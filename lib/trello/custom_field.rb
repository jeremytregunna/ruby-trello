module Trello
  # A Custom Field that can be activated on a board.
  #
  # @!attribute id
  #   @return [String]
  # @!attribute idModel
  #   @return [String]
  # @!attribute modelType
  #   @return [String]
  # @!attribute fieldGroup
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
    register_attributes :id, :idModel, :modelType, :fieldGroup, :name, :pos, :type

  end
end
