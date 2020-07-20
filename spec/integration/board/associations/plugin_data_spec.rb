require 'spec_helper'

RSpec.describe 'Trello::Board#plugin_data' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get plugin data' do
    VCR.use_cassette('can_get_plugin_data_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      plugin_data = board.plugin_data

      expect(plugin_data).to be_a(Array)
      # expect(plugin_data[0]).to be_a(Trello::PluginDatum)
    end
  end

end
