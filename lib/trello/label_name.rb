module Trello

  # A colored Label attached to a card
  class LabelName < BasicDataAlpha
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
