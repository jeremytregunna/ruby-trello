require 'spec_helper'

RSpec.describe 'Trello::Card#voters' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get voters' do
    VCR.use_cassette('get_voters_of_card') do
      card = Trello::Card.find('5e94f5e837592f1a80a2059c')
      voters = card.voters
      expect(voters.count).to be > 0
      expect(voters[0]).to be_a(Trello::Member)
    end
  end

end
