module Trello
  # An Item is a basic task that can be checked off and marked as completed.
  class Item < BasicData
    attr_reader :id, :name, :type

    # Updates the fields of an item.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item.
    def update_fields(fields)
      @id   = fields['id']
      @name = fields['name']
      @type = fields['type']
    end
  end
end