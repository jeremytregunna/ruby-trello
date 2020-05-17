require 'spec_helper'

RSpec.describe 'Trello::Board#actions' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get actions' do
    VCR.use_cassette('can_get_actions_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      actions = board.actions

      expect(actions).to be_a(Array)
      expect(actions[0]).to be_a(Trello::Action)
    end
  end

end
