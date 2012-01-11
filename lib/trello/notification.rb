module Trello
  # Notifications for members
  #
  # This class is not yet implemented as the feature set is not known yet.
  class Notification < BasicData
    def update_fields(fields)
      @id = fields['id']
    end
  end
end