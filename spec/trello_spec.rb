require 'spec_helper'

include Trello
include Trello::Authorization

describe Trello do
  before do
    Trello.reset!
  end

  describe "self.configure" do
    it "builds auth policy client uses to make requests" do
      Trello.configure do |config|
        config.developer_public_key = 'developer_public_key'
        config.member_token         = 'member_token'
      end

      TInternet.stub(:execute)
      Trello.auth_policy.should_receive(:authorize)
      Trello.client.get(:member, params = {})
    end

    it "configures basic auth policy" do
      Trello.configure do |config|
        config.developer_public_key = 'developer_public_key'
        config.member_token         = 'member_token'
      end

      auth_policy = Trello.auth_policy
      auth_policy.should be_a(BasicAuthPolicy)
      auth_policy.developer_public_key.should eq('developer_public_key')
      auth_policy.member_token.should eq('member_token')
    end

    context "oauth" do
      before do
        Trello.configure do |config|
          config.consumer_key     = 'consumer_key'
          config.consumer_secret  = 'consumer_secret'
          config.oauth_token      = 'oauth_token'
          config.oauth_secret     = 'oauth_secret'
        end
      end

      it "configures oauth policy" do
        auth_policy = Trello.auth_policy

        auth_policy.should be_a(OAuthPolicy)
        auth_policy.consumer_key.should eq('consumer_key')
        auth_policy.consumer_secret.should eq('consumer_secret')
        auth_policy.oauth_token.should eq('oauth_token')
        auth_policy.oauth_secret.should eq('oauth_secret')
      end

      it "updates auth policy configuration" do
        auth_policy = Trello.auth_policy
        auth_policy.consumer_key.should eq('consumer_key')

        Trello.configure do |config|
          config.consumer_key     = 'new_consumer_key'
          config.consumer_secret  = 'new_consumer_secret'
          config.oauth_token      = 'new_oauth_token'
          config.oauth_secret     = 'new_oauth_secret'
        end

        auth_policy = Trello.auth_policy

        auth_policy.should be_a(OAuthPolicy)
        auth_policy.consumer_key.should eq('new_consumer_key')
        auth_policy.consumer_secret.should eq('new_consumer_secret')
        auth_policy.oauth_token.should eq('new_oauth_token')
        auth_policy.oauth_secret.should eq('new_oauth_secret')
      end
    end
  end
end
