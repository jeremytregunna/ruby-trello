require "spec_helper"

include Trello

describe Configuration do
  let(:configuration) { Configuration.new }

  it "has a consumer_key attribute" do
    configuration.consumer_key = 'consumer_key'
    configuration.consumer_key.should eq('consumer_key')
  end

  it "has a consumer_secret attribute" do
    configuration.consumer_secret = 'consumer_secret'
    configuration.consumer_secret.should eq('consumer_secret')
  end

  it "has a oauth_token attribute" do
    configuration.oauth_token = 'oauth_token'
    configuration.oauth_token.should eq('oauth_token')
  end

  it "has a oauth_secret attribute" do
    configuration.oauth_secret = 'oauth_secret'
    configuration.oauth_secret.should eq('oauth_secret')
  end

  it "has a developer public key attribute" do
    configuration.developer_public_key = 'developer_public_key'
    configuration.developer_public_key.should eq('developer_public_key')
  end

  it "has a member token attribute" do
    configuration.member_token = 'member_token'
    configuration.member_token.should eq('member_token')
  end

  describe "initialize" do
    it "sets key attributes provided as a hash" do
      configuration = Configuration.new(
        :consumer_key => 'consumer_key',
        :consumer_secret => 'consumer_secret',
        :oauth_token => 'oauth_token',
        :oauth_secret => 'oauth_secret'
      )
      configuration.consumer_key.should eq('consumer_key')
      configuration.consumer_secret.should eq('consumer_secret')
      configuration.oauth_token.should eq('oauth_token')
      configuration.oauth_secret.should eq('oauth_secret')
    end
  end

  describe "#credentials" do
    let(:configuration) { Configuration.new(attributes) }

    it "returns an empty if no attributes specified" do
      Configuration.new({}).credentials.should eq({})
    end

    it "returns an empty if attributes incomplete" do
      Configuration.new(:consumer_key => 'consumer_key').credentials.should eq({})
    end

    it 'returns a hash of oauth attributes' do
      configuration = Configuration.new(
        :consumer_key => 'consumer_key',
        :consumer_secret => 'consumer_secret',
        :oauth_token => 'oauth_token',
        :oauth_secret => 'oauth_secret'
      )
      configuration.credentials.should eq(
        :consumer_key => 'consumer_key',
        :consumer_secret => 'consumer_secret',
        :oauth_token => 'oauth_token',
        :oauth_secret => 'oauth_secret'
      )
    end

    it "returns a hash of basic auth policy attributes" do
      configuration = Configuration.new(
        :developer_public_key => 'developer_public_key',
        :member_token => 'member_token'
      )
      configuration.credentials.should eq(
        :developer_public_key => 'developer_public_key',
        :member_token => 'member_token'
      )
    end
  end
end
