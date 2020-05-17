require 'spec_helper'

RSpec.describe 'Trello::Board#label_names' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get label_names' do
    VCR.use_cassette('can_get_label_names_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      label_names = board.label_names

      expect(label_names).to be_a(Trello::LabelName)
    end
  end

end
