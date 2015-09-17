module Trello

  # A colored Label attached to a card
  class LabelName < BasicData
    register_attributes :yellow, :red, :orange, :green, :purple, :blue, :sky, :pink, :lime, :black

    # Update the fields of a label.
    #
    # Supply a hash of stringkeyed data retrieved from the Trello API representing
    # a label.
    def update_fields(fields)
      attributes[:yellow]  = fields['yellow']
      attributes[:red] = fields['red']
      attributes[:orange] = fields['orange']
      attributes[:green] = fields['green']
      attributes[:purple] = fields['purple']
      attributes[:blue] = fields['blue']
      attributes[:sky] = fields['sky']
      attributes[:pink] = fields['pink']
      attributes[:lime] = fields['lime']
      attributes[:black] = fields['black']

      self
    end

    one :board, path: :boards, using: :board_id

    many :cards, filter: :all

  end
end
