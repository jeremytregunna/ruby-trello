module Trello
  # A colored Label attached to a card
  #
  # @!attribute [r] yellow
  # @!attribute [r] red
  # @!attribute [r] orange
  # @!attribute [r] green
  # @!attribute [r] purple
  # @!attribute [r] blue
  # @!attribute [r] sky
  # @!attribute [r] pink
  # @!attribute [r] lime
  # @!attribute [r] black
  class LabelName < BasicData
    schema do
      attribute :yellow, readonly: true
      attribute :red, readonly: true
      attribute :orange, readonly: true
      attribute :green, readonly: true
      attribute :purple, readonly: true
      attribute :blue, readonly: true
      attribute :sky, readonly: true
      attribute :pink, readonly: true
      attribute :lime, readonly: true
      attribute :black, readonly: true
    end
  end
end
