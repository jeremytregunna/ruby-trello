require 'spec_helper'

RSpec.describe 'Trello::Card#check_item_states' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get check_item_states' do
    VCR.use_cassette('get_check_item_states_of_card') do
      card = Trello::Card.find('5e946acb3cc40322434c214e')
      check_item_states = card.check_item_states
      expect(check_item_states.count).to be > 0
      expect(check_item_states[0]).to be_a(Trello::CheckItemState)
    end
  end

end
