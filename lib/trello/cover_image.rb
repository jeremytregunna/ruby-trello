module Trello
  # The trello cover image
  #
  # This is normally an attachment that the user (or trello) has set
  # as the cover image
  class CoverImage < Attachment
    # Same with Attachment may need refactor it to support inheritance
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
