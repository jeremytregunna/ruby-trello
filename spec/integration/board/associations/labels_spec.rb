require 'spec_helper'

RSpec.describe 'Trello::Board#labelds' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get labels' do
    VCR.use_cassette('can_get_labels_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      labels = board.labels

      expect(labels).to be_a(Array)
      expect(labels[0]).to be_a(Trello::Label)
    end
  end

end
