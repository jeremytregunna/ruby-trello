require 'spec_helper'

RSpec.describe 'Trello::Card#plugin_data' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get plugin_data' do
    VCR.use_cassette('get_plugin_data_of_card') do
      card = Trello::Card.find('5e94eb036ad95f19112bd187')
      plugin_data = card.plugin_data
      expect(plugin_data.count).to be > 0
      expect(plugin_data[0]).to be_a(Trello::PluginDatum)
      expect(plugin_data[0].idModel).to eq(card.id)
    end
  end

end
