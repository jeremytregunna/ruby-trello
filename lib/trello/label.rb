module Trello

  # A colored Label attached to a card
  #
  # @!attribute [rw] id
  #   @return [String]
  # @!attribute [rw] color
  #   @return [String]
  class Label < BasicData
    register_attributes :id, :name, :board_id, :uses,
      readonly: [ :id, :uses, :board_id ]
    validates_presence_of :id, :uses, :board_id, :name
    validates_length_of   :name,        in: 1..16384
        
    SYMBOL_TO_STRING = {
      id: 'id',
      name: 'name',
      board_id: 'idBoard',
      color: 'color',
      uses: 'uses'
    }

    class << self
      # Find a specific card by its id.
      def find(id, params = {})
        client.find(:label, id, params)
      end

      # Create a new card and save it on Trello.
      def create(options)
        client.create(:label,
          'name' => options[:name],
          'idBoard' => options[:board_id],
          'color'   => options[:color],
        )
      end

      # Label colours
      def label_colours
        %w{green yellow orange red purple blue sky lime pink black}
      end
    end

    define_attribute_methods [:color]

    def color
      @attributes[:color]
    end

    def color= colour
      unless Label.label_colours.include? colour
        errors.add(:label, "color '#{colour}' does not exist")
        return Trello.logger.warn "The label colour '#{colour}' does not exist."
      end

      self.send(:"color_will_change!") unless colour == @attributes[:color]
      @attributes[:color] = colour
    end

    # Update the fields of a label.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # a label.
    def update_fields(fields)
      attributes[:id] = fields['id']
      attributes[:name]  = fields['name']
      attributes[:color] = fields['color']
      attributes[:board_id] = fields['idBoard']
      attributes[:uses] = fields['uses']
      self
    end

    # Returns a reference to the board this label is currently connected.
    one :board, path: :boards, using: :board_id

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      client.post("/labels", {
        name:   name,
        color:   color,
        idBoard: board_id,
      }).json_into(self)
    end

    # Update an existing record.
    # Warning, this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/labels/#{id}", payload)
    end

    # Delete this card
    def delete
      client.delete("/labels/#{id}")
    end
  end
end
