require 'spec_helper'

RSpec.describe 'Trello::List#board' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get board' do
    VCR.use_cassette('get_board_of_list') do
      list = Trello::List.find('5f52526ebda8ea4a96445dbf')
      board = list.board

      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq(list.board_id)
    end
  end

end
