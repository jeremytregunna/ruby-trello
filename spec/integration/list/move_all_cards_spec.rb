require 'spec_helper'

RSpec.describe 'Trell::List#move_all_cards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can move all cards to another list' do
    VCR.use_cassette('can_move_all_cards_to_another_list') do
      l1 = Trello::List.find('5e94eafdf553d46ea525faa7')
      l2 = Trello::List.find('5e94fa1248c5e41ad0464a7f')

      l1_cards = l1.cards
      l2_cards = l2.cards

      expect(l1_cards.count).to eq(1)
      expect(l2_cards.count).to eq(0)

      l1.move_all_cards(l2)

      l1 = Trello::List.find('5e94eafdf553d46ea525faa7')
      l2 = Trello::List.find('5e94fa1248c5e41ad0464a7f')

      l1_cards = l1.cards
      l2_cards = l2.cards

      expect(l1_cards.count).to eq(0)
      expect(l2_cards.count).to eq(1)
    end
  end
end
