require 'spec_helper'

RSpec.describe 'Trello::Board#lists' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get lists' do
    VCR.use_cassette('can_get_lists_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      lists = board.lists

      expect(lists).to be_a(Array)
      expect(lists[0]).to be_a(Trello::List)
    end
  end

end
