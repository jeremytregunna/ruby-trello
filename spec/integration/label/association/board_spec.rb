require 'spec_helper'

RSpec.describe 'Trello::Label#board' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get board' do
    VCR.use_cassette('can_get_boards_of_label') do
      label = Trello::Label.find('5e70f5be7669b225494e4fff')
      board = label.board

      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq(label.board_id)
    end
  end

end
