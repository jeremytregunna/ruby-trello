require 'spec_helper'

RSpec.describe 'Trello::Card#move_to_list' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can move a card to another list' do
    VCR.use_cassette('can_move_a_card_to_another_list') do
      list = Trello::List.find('5e95d1b2342114318522f3f1')
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
      response = card.move_to_list(list)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['idList']).to eq('5e95d1b2342114318522f3f1')
      expect(body['idList']).not_to eq(card.list_id)
    end
  end
end
