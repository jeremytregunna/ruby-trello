require 'spec_helper'

RSpec.describe 'Trello::Card#list' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get list' do
    VCR.use_cassette('get_list_of_card') do
      card = Trello::Card.find('5e946acb3cc40322434c214e')
      list = card.list
      expect(list.id).to eq(card.list_id)
    end
  end

end
