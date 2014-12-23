require 'spec_helper'

describe Trello::Configuration do
  let(:configuration) { Trello::Configuration.new }

  it 'has a consumer_key attribute' do
    configuration.consumer_key = 'consumer_key'
    configuration.consumer_key.should eq('consumer_key')
  end

  it 'has a consumer_secret attribute' do
    configuration.consumer_secret = 'consumer_secret'
    configuration.consumer_secret.should eq('consumer_secret')
  end

  it 'has a oauth_token attribute' do
    configuration.oauth_token = 'oauth_token'
    configuration.oauth_token.should eq('oauth_token')
  end

  it 'has a oauth_token_secret attribute' do
    configuration.oauth_token_secret = 'oauth_token_secret'
    configuration.oauth_token_secret.should eq('oauth_token_secret')
  end

  it 'has a developer public key attribute' do
    configuration.developer_public_key = 'developer_public_key'
    configuration.developer_public_key.should eq('developer_public_key')
  end

  it 'has a member token attribute' do
    configuration.member_token = 'member_token'
    configuration.member_token.should eq('member_token')
  end

  it 'has a callback (for oauth)' do
    callback = -> { 'foobar' }
    configuration.callback = callback
    configuration.callback.call.should eq('foobar')
  end

  it 'has a return_url' do
    configuration.return_url = 'http://www.example.com/callback'
    configuration.return_url.should eq('http://www.example.com/callback')
  end

  describe 'initialize' do
    it 'sets key attributes provided as a hash' do
      configuration = Trello::Configuration.new(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret',
        oauth_token: 'oauth_token',
        oauth_token_secret: 'oauth_token_secret'
      )
      configuration.consumer_key.should eq('consumer_key')
      configuration.consumer_secret.should eq('consumer_secret')
      configuration.oauth_token.should eq('oauth_token')
      configuration.oauth_token_secret.should eq('oauth_token_secret')
    end
  end

  describe '#credentials' do
    let(:configuration) { Trello::Configuration.new(attributes) }

    it 'returns an empty if no attributes specified' do
      Trello::Configuration.new({}).credentials.should eq({})
    end

    it 'returns an empty if attributes incomplete' do
      Trello::Configuration.new(consumer_key: 'consumer_key').credentials.should eq({})
    end

    it 'returns a hash of oauth attributes' do
      configuration = Trello::Configuration.new(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret',
        oauth_token: 'oauth_token',
        oauth_token_secret: 'oauth_token_secret'
      )
      configuration.credentials.should eq(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret',
        oauth_token: 'oauth_token',
        oauth_token_secret: 'oauth_token_secret'
      )
    end

    it 'includes callback and return url if given' do
      configuration = Trello::Configuration.new(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret',
        return_url: 'http://example.com',
        callback: 'callback'
      )
      configuration.credentials.should eq(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret',
        return_url: 'http://example.com',
        callback: 'callback'
      )
    end

    it 'returns a hash of basic auth policy attributes' do
      configuration = Trello::Configuration.new(
        developer_public_key: 'developer_public_key',
        member_token: 'member_token'
      )
      configuration.credentials.should eq(
        developer_public_key: 'developer_public_key',
        member_token: 'member_token'
      )
    end
  end
end
