require 'spec_helper'

RSpec.describe 'Trell::Card add and remove label' do
  include IntegrationHelpers

  before { setup_trello }

  describe '#add_label' do
    it 'can success add a label on a card' do
      VCR.use_cassette('can_add_label_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
        label = Trello::Label.find('5e94f5de7669b2254978bd14')
        label.name = 'label name' # For past name valiation

        response = card.add_label(label)
        expect(response.code).to eq(200)
        body = JSON.parse(response.body)
        expect(body.first).to eq('5e94f5de7669b2254978bd14')
      end
    end
  end

  describe '#remove_label' do
    it 'can success remove a label on a card' do
      VCR.use_cassette('can_remove_label_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
        label = Trello::Label.find('5e94f5de7669b2254978bd14')
        label.name = 'label name' # For past name valiation

        response = card.remove_label(label)
        expect(response.code).to eq(200)
      end
    end
  end
end
