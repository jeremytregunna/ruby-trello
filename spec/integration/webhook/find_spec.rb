require 'spec_helper'

RSpec.describe 'Trello::Webhook#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('webhook_find_with_id') do
      webhook = Trello::Webhook.find('5fa8a1e0009b2a6a669e6efa')
      expect(webhook).to be_a(Trello::Webhook)

      expect(webhook.id).not_to be_nil
      expect(webhook.description).not_to be_nil
      expect(webhook.model_id).not_to be_nil
      expect(webhook.callback_url).not_to be_nil
      expect(webhook.active).not_to be_nil
      expect(webhook.consecutive_failures).not_to be_nil
    end
  end

end
