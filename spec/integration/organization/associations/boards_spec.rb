require 'spec_helper'

RSpec.describe 'Trello::Organization#boards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get boards' do
    VCR.use_cassette('can_get_boards_of_organization') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      boards = organization.boards

      expect(boards).to be_a(Array)
      expect(boards[0]).to be_a(Trello::Board)
    end
  end

end
