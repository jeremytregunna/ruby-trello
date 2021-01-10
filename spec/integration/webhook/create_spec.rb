require 'spec_helper'

RSpec.describe 'Trello::Webhook.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the custom_field' do
    VCR.use_cassette('can_success_create_a_webhook') do
      webhook = Trello::Webhook.create(
        description: 'test',
        model_id: '5fa759f1564c6e5bb803c61e',
        callback_url: 'https://example.com/webhook/trello_callbacks',
        active: true
      )
      expect(webhook).to be_a(Trello::Webhook)

      expect(webhook.id).not_to be_nil
      expect(webhook.description).to eq('test')
      expect(webhook.model_id).to eq('5fa759f1564c6e5bb803c61e')
      expect(webhook.callback_url).to eq('https://example.com/webhook/trello_callbacks')
      expect(webhook.active).to eq(true)
      expect(webhook.consecutive_failures).to eq(0)
      expect(webhook.first_consecutive_fail_date).to be_nil
    end
  end
end
