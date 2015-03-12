module Trello

  # A colored Label attached to a card
  class Label < BasicData
    register_attributes :name, :color, :uses, :id

    # Update the fields of a label.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # a label.
    def update_fields(fields)
      attributes[:name]  = fields['name']
      attributes[:color] = fields['color']
      attributes[:uses] = fields['uses']
      attributes[:id] = fields['id']
      self
    end
  end

end
