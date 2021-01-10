require 'spec_helper'

RSpec.describe 'Trell::List#archive_all_cards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can arvhice all cards of list' do
    VCR.use_cassette('can_arvhice_all_cards_of_list') do
      list = Trello::List.find('5e94eafdf553d46ea525faa7')
      cards = list.cards
      expect(cards.count).to eq(2)

      list.archive_all_cards

      cards = list.cards
      expect(cards.count).to eq(0)
    end
  end
end
