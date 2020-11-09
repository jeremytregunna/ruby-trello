require 'spec_helper'

RSpec.describe 'Trell::Webhook.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a webhook' do
    VCR.use_cassette('can_success_update_bong_a_webhook') do
      webhook = Trello::Webhook.find('5fa8a1e0009b2a6a669e6efa')

      expect(webhook.description).to eq('test')

      webhook.description = 'Test - Changed'

      webhook.update!

      expect(webhook.description).to eq('Test - Changed')
      webhook = Trello::Webhook.find('5fa8a1e0009b2a6a669e6efa')
      expect(webhook.description).to eq('Test - Changed')
    end
  end

end
