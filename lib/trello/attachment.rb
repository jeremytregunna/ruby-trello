module Trello
  # A file or url that is linked to another Trello object
  class Attachment < BasicData
    register_attributes :name, :id

    # Update the fields of an attachment.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # an attachment.
    def update_fields(fields)
      attributes[:name]  = fields['name']
      attributes[:id] = fields['id']
      self
    end
  end
end
