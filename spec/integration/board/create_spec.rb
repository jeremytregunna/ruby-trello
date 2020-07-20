require 'spec_helper'

RSpec.describe 'Trello::Board.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the board' do
    VCR.use_cassette('can_success_create_a_board') do
      board = Trello::Board.create(
        name: 'IT 99',
        description: 'testing board create',
        closed: false,
        organization_id: '5e93ba154634282b6df23bcc'
      )
      expect(board).to be_a(Trello::Board)

      expect(board.name).to eq('IT 99')
      expect(board.description).to eq('testing board create')
      expect(board.id).not_to be_nil
      expect(board.closed).to be_falsy
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')
    end
  end

end
