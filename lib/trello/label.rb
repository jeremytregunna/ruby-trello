module Trello

  # A colored Label attached to a card
  class Label < BasicData
    register_attributes :name, :color

    # Update the fields of a label.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # a label.
    def update_fields(fields)
      attributes[:name]  = fields['name']
      attributes[:color] = fields['color']
      self
    end

    def cards 
      cards = client.get("/cards/labels/#{name}").json_into(Card)
      MultiAssociation.new(self, cards).proxy
    end

  end

end
