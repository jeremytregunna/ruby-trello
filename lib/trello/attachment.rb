module Trello
  # A file or url that is linked to a Trello card
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] position
  #   @return [Float]
  # @!attribute [r] bytes
  #   @return [Fixnum]
  # @!attribute [r] member_id
  #   @return [String]
  # @!attribute [r] date
  #   @return [Datetime]
  # @!attribute [r] is_upload
  #   @return [Boolean]
  # @!attribute [r] previews
  #   @return [Array]
  # @!attribute [r] file_name
  #   @return [String]
  # @!attribute [r] edge_color
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] url
  #   @return [String]
  # @!attribute [rw] mime_type
  #   @return [String]
  # @!attribute [w] file
  #   @return [String]
  # @!attribute [w] set_as_cover
  #   @return [Boolean]
  class Attachment < BasicData
    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :position, readonly: true, remote_key: 'pos'
      attribute :bytes, readonly: true
      attribute :member_id, remote_key: 'idMember', readonly: true
      attribute :date, serializer: 'Time', readonly: true
      attribute :is_upload, remote_key: 'isUpload', readonly: true
      attribute :previews, readonly: true
      attribute :file_name, remote_key: 'fileName', readonly: true
      attribute :edge_color, remote_key: 'edgeColor', readonly: true

      # Writable but create only
      attribute :name, create_only: true
      attribute :url, create_only: true
      attribute :mime_type, remote_key: 'mimeType', create_only: true
      attribute :file, create_only: true
      attribute :set_as_cover, remote_key: 'setCover', create_only: true
    end
  end
end
