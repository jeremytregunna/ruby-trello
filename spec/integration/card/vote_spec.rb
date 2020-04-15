require 'spec_helper'

RSpec.describe 'Trell::Card#upvote #remove_upvote' do
  include IntegrationHelpers

  before { setup_trello }

  describe '#upvote' do
    it 'can success upvote on a card' do
      VCR.use_cassette('can_upvote_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')

        expect(card.voters.count).to eq(0)
        card.upvote
        expect(card.voters.count).to eq(1)
      end
    end

    it "won't raise error when already voted" do
      VCR.use_cassette('revote_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')

        expect(card.voters.count).to eq(1)
        expect { card.upvote }.not_to raise_error(Trello::Error)
        expect(card.voters.count).to eq(1)
      end
    end
  end

  describe '#remove_upvote' do
    it 'can success remove an upvote on a card' do
      VCR.use_cassette('can_remove_an_upvote_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')

        expect(card.voters.count).to eq(1)
        card.remove_upvote
        expect(card.voters.count).to eq(0)
      end
    end

    it "won't raise error when haven't voted" do
      VCR.use_cassette('remove_upvote_on_a_card_when_have_not_voted') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')

        expect(card.voters.count).to eq(0)
        expect { card.remove_upvote }.not_to raise_error(Trello::Error)
      end
    end
  end
end
