require 'spec_helper'

RSpec.describe 'Trello::Member#cards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get cards' do
    VCR.use_cassette('can_get_cards_of_member') do
      member = Trello::Member.find('hoppertest')
      cards = member.cards

      expect(cards).to be_a(Array)
      expect(cards[0]).to be_a(Trello::Card)
    end
  end

end
