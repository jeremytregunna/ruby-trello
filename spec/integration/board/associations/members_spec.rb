require 'spec_helper'

RSpec.describe 'Trello::Board#members' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get members' do
    VCR.use_cassette('can_get_members_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      members = board.members

      expect(members).to be_a(Array)
      expect(members[0]).to be_a(Trello::Member)
    end
  end

end
