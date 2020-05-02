require 'spec_helper'

RSpec.describe 'Trello::Card#custom_field_items' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get custom_field_items' do
    VCR.use_cassette('get_custom_field_items_of_card') do
      card = Trello::Card.find('5e94ee7df8784d61ee48319e')
      custom_field_items = card.custom_field_items
      expect(custom_field_items.count).to be > 0
      expect(custom_field_items[0]).to be_a(Trello::CustomFieldItem)
      expect(custom_field_items[0].model_id).to eq(card.id)
    end
  end

end
