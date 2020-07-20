require 'spec_helper'

RSpec.describe 'Trello::Board#checklists' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get checklists' do
    VCR.use_cassette('can_get_checklists_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      checklists = board.checklists

      expect(checklists).to be_a(Array)
      expect(checklists[0]).to be_a(Trello::Checklist)
    end
  end

end
