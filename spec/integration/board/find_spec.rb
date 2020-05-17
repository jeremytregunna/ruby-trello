require 'spec_helper'

RSpec.describe 'Trello::Board#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('board_find_with_id_and_get_all_fields') do
      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')
      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq('5e93ba403f1ab3603ba81a09')
      expect(board.name).not_to be_nil
      expect(board.description).not_to be_nil
      expect(board.closed).not_to be_nil
      expect(board.url).not_to be_nil
      expect(board.organization_id).not_to be_nil
      expect(board.prefs).not_to be_empty

      # API respnose doesn't contains below two attributes anymore.
      # Consider remove them in codeabase.
      # expect(board.starred).not_to be_nil
      # expect(board.last_activity_date).not_to be_nil
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('board_find_with_id_and_get_specific_fields') do
      board = Trello::Board.find('5e93ba403f1ab3603ba81a09', fields: 'name,desc')
      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq('5e93ba403f1ab3603ba81a09')
      expect(board.name).not_to be_nil
      expect(board.description).not_to be_nil

      expect(board.closed).to be_nil
      expect(board.url).to be_nil
      expect(board.organization_id).to be_nil
      expect(board.prefs).to be_empty
    end
  end

end
