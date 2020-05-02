require 'spec_helper'

RSpec.describe 'Trell::Card#create_new_checklist' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can create a checllist to a card' do
    VCR.use_cassette('can_success_create_new_checklist_to_a_card') do
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      response = card.create_new_checklist('ToDo')

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['name']).to eq('ToDo')
      expect(body['idCard']).to eq(card.id)
    end
  end
end
