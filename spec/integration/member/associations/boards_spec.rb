require 'spec_helper'

RSpec.describe 'Trello::Member#boards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get boards' do
    VCR.use_cassette('get_boards_of_member') do
      member = Trello::Member.find('hoppertest')
      boards = member.boards

      expect(boards).to be_a(Array)
      expect(boards[0]).to be_a(Trello::Board)
    end
  end

end
