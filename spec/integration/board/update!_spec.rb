require 'spec_helper'

RSpec.describe 'Trell::Board.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a card with all fields' do
    VCR.use_cassette('can_success_update_bong_a_board') do
      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')

      expect(board.name).to eq('IT 1')
      expect(board.description).to eq('')
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')

      board.name = 'IT 1 - Changed'
      board.description = 'This is a test board called IT 1'
      board.closed = false
      board.organization_id = '5eb427016b5a464a74803f1c'
      board.visibility_level = 'org'
      board.enable_self_join = false
      board.enable_card_covers = false
      board.voting_permission_level = 'org'
      board.comment_permission_level = 'org'
      board.background_color = 'green'

      board.update!

      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')
      expect(board.name).to eq('IT 1 - Changed')
      expect(board.description).to eq('This is a test board called IT 1')
      expect(board.closed).to eq(false)
      expect(board.organization_id).to eq('5eb427016b5a464a74803f1c')
      expect(board.visibility_level).to eq('org')
      expect(board.enable_self_join).to eq(false)
      expect(board.enable_card_covers).to eq(false)
      expect(board.voting_permission_level).to eq('org')
      expect(board.comment_permission_level).to eq('org')
      expect(board.background_color).to eq('green')
    end
  end

  it 'can update! a card with specific fields' do
    VCR.use_cassette('can_success_update_bong_a_board_with_specific_fields') do
      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')

      expect(board.name).to eq('IT 1')
      expect(board.description).to eq('This is a test board called IT 1')
      expect(board.comment_permission_level).to eq('org')

      board.name = 'IT 1 - Changed'
      board.comment_permission_level = 'members'

      board.update!

      board = Trello::Board.find('5e93ba403f1ab3603ba81a09')
      expect(board.name).to eq('IT 1 - Changed')
      expect(board.description).to eq('This is a test board called IT 1')
      expect(board.comment_permission_level).to eq('members')
    end
  end
end
