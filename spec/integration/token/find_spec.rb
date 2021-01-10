require 'spec_helper'

RSpec.describe 'Trello::Token#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with token string' do
    VCR.use_cassette('token_find_with_token_string') do
      token = Trello::Token.find('MEMBER_TOKEN')
      expect(token).to be_a(Trello::Token)

      expect(token.id).not_to be_nil
      expect(token.identifier).not_to be_nil
      expect(token.member_id).not_to be_nil
      expect(token.created_at).not_to be_nil
      # expect(token.expires_at).not_to be_nil
      expect(token.permissions).not_to be_nil
      expect(token.webhooks).not_to be_nil
      expect(token.webhooks[0]).to be_a(Trello::Webhook)
    end
  end

end
