require 'spec_helper'

RSpec.describe 'Trell::Card#add_checklist' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can copy a checklist from another card' do
    VCR.use_cassette('can_success_copy_checklist_to_a_card') do
      checklist = Trello::Checklist.find('5e948a1a9e2cfd0ef6818e89')
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      response = card.add_checklist(checklist, name: 'ToDo2', position: 'top')

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['name']).to eq('ToDo2')
    end
  end

  it 'can copy a checklist from another card without specify name and position' do
    VCR.use_cassette('can_success_copy_checklist_to_a_card_without_name_pos') do
      checklist = Trello::Checklist.find('5e948a1a9e2cfd0ef6818e89')
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      response = card.add_checklist(checklist)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['idCard']).to eq(card.id)
      expect(body['name']).to eq(checklist.name)
    end
  end
end
