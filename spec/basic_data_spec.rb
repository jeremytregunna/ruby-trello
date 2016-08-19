require 'spec_helper'

module Trello
  describe BasicData do
    include Helpers

    describe '#refresh!' do

      # NOTE: card implments BasicData
      let(:card)   { client.find(:card, 'abcdef123456789123456789') }
      let(:client) { Client.new }

      before do
        allow(client)
          .to receive(:get)
          .with("/cards/abcdef123456789123456789", {})
          .and_return JSON.generate(cards_details.first)
      end

      context 'when another source has updated the card and the object is stale' do
        it 'reloads the object with the updated data' do
          expect(card.labels.length).to eql(4) # asserting the default
          # mimick another service updating the card
          # i.e. remove labels
          new_card_details = cards_details.first.clone
          new_card_details['idLabels'] = [ new_card_details['idLabels'].first ]

          # mock next request for updated data
          expect_any_instance_of(Client)
            .to receive(:get)
            .with("/cards/abcdef123456789123456789", {})
            .and_return JSON.generate(new_card_details)

          updated_card = card.refresh!
          expect(updated_card.labels.length).to eql(1)
        end
      end
    end
  end
end
