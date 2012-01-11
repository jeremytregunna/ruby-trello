module Trello
  # Notifications for members
  #
  # This class is not yet implemented as the feature set is not known yet.
  class Notification < BasicData
    def initialize(fields = {})
      @id = fields['id']
    end
  end
end