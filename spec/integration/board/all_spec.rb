require 'spec_helper'

RSpec.describe 'Trello::Board.all' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success return all boards for the current user' do
    VCR.use_cassette('can_success_return_all_boards_of_current_user') do
      boards = Trello::Board.all
      expect(boards.count).to be > 1
      expect(boards[0].name).to eq('IT 1')
      expect(boards[1].name).to eq('IT 2')
      expect(boards[2].name).to eq('IT 3')
      expect(boards[3].name).to eq('IT 4')
      expect(boards[4].name).to eq('IT 5')
    end
  end

end
