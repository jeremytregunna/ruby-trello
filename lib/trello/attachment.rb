module Trello
  # A file or url that is linked to a Trello card
  #
  # @!attribute id
  #   @return [String]
  # @!attribute name
  #   @return [String]
  # @!attribute url
  #   @return [String]
  # @!attribute bytes
  #   @return [Fixnum]
  # @!attribute date
  #   @return [Datetime]
  # @!attribute is_upload
  #   @return [Boolean]
  # @!attribute mime_type
  #   @return [String]
  class Attachment < BasicData
    register_attributes :name, :id, :url, :bytes, :member_id, :date, :is_upload, :mime_type
    # Update the fields of an attachment.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # an attachment.
    def update_fields(fields)
      attributes[:name]  = fields['name']
      attributes[:id] = fields['id']
      attributes[:url] = fields['url']
      attributes[:bytes] = fields['bytes'].to_i
      attributes[:member_id] = fields['idMember']
      attributes[:date] = Time.parse(fields['date'])
      attributes[:is_upload] = fields['isUpload']
      attributes[:mime_type] = fields['mimeType']
      self
    end
  end
end
