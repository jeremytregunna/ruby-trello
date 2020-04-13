require 'spec_helper'

RSpec.describe 'Trello::Card#board' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get board' do
    VCR.use_cassette('get_board_of_card') do
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      board = card.board
      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq(card.board_id)
    end
  end

end
