require 'spec_helper'

RSpec.describe 'Trello::Webhook#delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('webhook_delete') do
      webhook = Trello::Webhook.find('5fa8a1e0009b2a6a669e6efa')
      expect(webhook).to be_a(Trello::Webhook)

      webhook.delete

      expect {
        Trello::Webhook.find('5fa8a1e0009b2a6a669e6efa')
      }.to raise_error Trello::Error, 'The requested resource was not found.'
    end
  end

end
