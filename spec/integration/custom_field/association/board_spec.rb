require 'spec_helper'

RSpec.describe 'Trello::CustomField#board' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get board' do
    VCR.use_cassette('can_get_boards_of_custom_field') do
      custom_field = Trello::CustomField.find('5f60edcbe0610f8811951cae')
      board = custom_field.board

      expect(board).to be_a(Trello::Board)
      expect(board.id).to eq(custom_field.model_id)
    end
  end

end
