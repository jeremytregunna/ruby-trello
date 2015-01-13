module Trello
  # An Item is a basic task that can be checked off and marked as completed.
  class Item < BasicData
    register_attributes :id, :name, :type, :state, :pos, readonly: [ :id, :name, :type, :state, :pos ]
    validates_presence_of :id, :type

    # Updates the fields of an item.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item.
    def update_fields(fields)
      attributes[:id]    = fields['id']
      attributes[:name]  = fields['name']
      attributes[:type]  = fields['type']
      attributes[:state] = fields['state']
      attributes[:pos]   = fields['pos']
      self
    end
  end
end