require 'spec_helper'

RSpec.describe 'Trell::Board.save' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the board' do
    VCR.use_cassette('can_success_create_a_board') do
      board = Trello::Board.new(
        name: 'IT 99',
        description: 'testing board create',
        closed: false,
        organization_id: '5e93ba154634282b6df23bcc'
      )
      board.save

      expect(board.name).to eq('IT 99')
      expect(board.description).to eq('testing board create')
      expect(board.id).not_to be_nil
      expect(board.closed).to be_falsy
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')
    end
  end

  it 'can success update a board' do
    VCR.use_cassette('can_success_upate_a_board') do
      board = Trello::Board.find('5ec146e4f6a9bc121bc5b0b6')
      expect(board.description).to eq('testing board create')
      board.description = 'testing board create (changed)'
      board.save
      expect(board.description).to eq('testing board create (changed)')
    end
  end

end

