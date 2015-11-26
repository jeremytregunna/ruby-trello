require 'spec_helper'

module Trello
  RSpec.describe Utils do
    include Helpers

    describe "Trello::Card" do
      it "should convert an array of parsed json into cards" do
        cards = Trello::Card.from_json(cards_details)

        expect(cards.size).to eq(cards_details.size)

        card = cards.first
        expect(card).to be_a(Trello::Card)
        expect(card.name).to eq(cards_details.first['name'])
      end

      it "should convert a single parsed json into card" do
        card_details = cards_details.first
        card = Trello::Card.from_json(card_details)

        expect(card).to be_a(Trello::Card)
        expect(card.name).to eq(cards_details.first['name'])
      end
    end
  end
end
