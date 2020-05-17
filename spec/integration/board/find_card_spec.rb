require 'spec_helper'

RSpec.describe 'Trello::Board#find_card' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success get a card of board by card id' do
    VCR.use_cassette('can_success_get_card_of_board_by_card_id') do
      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')
      card = board.find_card('5e93ba665c58c44a46cb2ef9')
      expect(card).to be_a(Trello::Card)
      expect(card.id).to eq('5e93ba665c58c44a46cb2ef9')
      expect(card.name).to eq('C1')
    end
  end

end
