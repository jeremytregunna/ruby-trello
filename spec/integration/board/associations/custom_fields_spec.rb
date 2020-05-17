require 'spec_helper'

RSpec.describe 'Trello::Board#custom_fields' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get custom fields' do
    VCR.use_cassette('can_get_custom_fields_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      custom_fields = board.custom_fields

      expect(custom_fields).to be_a(Array)
      expect(custom_fields[0]).to be_a(Trello::CustomField)
    end
  end

end
