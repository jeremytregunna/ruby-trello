module Trello
  # A file or url that is linked to a Trello card
  #
  # @!attribute id
  #   @return [String]
  # @!attribute name
  #   @return [String]
  # @!attribute url
  #   @return [String]
  # @!attribute pos
  #   @return [Float]
  # @!attribute bytes
  #   @return [Fixnum]
  # @!attribute date
  #   @return [Datetime]
  # @!attribute is_upload
  #   @return [Boolean]
  # @!attribute mime_type
  #   @return [String]
  class Attachment < BasicData
    register_attributes :name, :id, :pos, :url, :bytes, :member_id, :date, :is_upload, :mime_type, :previews
    # Update the fields of an attachment.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # an attachment.
    def update_fields(fields)
      attributes[:name]      = fields['name'] || attributes[:name]
      attributes[:id]        = fields['id'] || attributes[:id]
      attributes[:pos]       = fields['pos'] || attributes[:pos]
      attributes[:url]       = fields['url'] || attributes[:url]
      attributes[:bytes]     = fields['bytes'].to_i || attributes[:bytes]
      attributes[:member_id] = fields['idMember'] || attributes[:member_id]
      attributes[:date]      = Time.parse(fields['date']).presence || attributes[:date]
      attributes[:is_upload] = fields['isUpload'] if fields.has_key?('isUpload')
      attributes[:mime_type] = fields['mimeType'] || attributes[:mime_type]
      attributes[:previews]  = fields['previews'] if fields.has_key?('previews')
      self
    end
  end
end
