require 'spec_helper'

RSpec.describe 'Trello::List#cards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get cards' do
    VCR.use_cassette('can_get_cards_of_list') do
      list = Trello::List.find('5e94fa1248c5e41ad0464a7f')
      cards = list.cards

      expect(cards).to be_a(Array)
      expect(cards[0]).to be_a(Trello::Card)
    end
  end

end
