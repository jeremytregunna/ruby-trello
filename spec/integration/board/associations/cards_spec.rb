require 'spec_helper'

RSpec.describe 'Trello::Board#cards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get cards' do
    VCR.use_cassette('can_get_cards_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      cards = board.cards

      expect(cards).to be_a(Array)
      expect(cards[0]).to be_a(Trello::Card)
    end
  end

end
