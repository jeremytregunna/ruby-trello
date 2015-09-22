require 'spec_helper'

include Trello
include Trello::Authorization

describe OAuthPolicy do
  before do
    OAuthPolicy.consumer_credential = OAuthCredential.new 'xxx', 'xxx'
    OAuthPolicy.token = nil
  end

  describe '#consumer_credential' do
    it 'uses class setting if available' do
      policy = OAuthPolicy.new
      expect(policy.consumer_credential.key).to eq('xxx')
      expect(policy.consumer_credential.secret).to eq('xxx')
    end

    it 'is built from given consumer_key and consumer_secret' do
      policy = OAuthPolicy.new(
        consumer_key: 'consumer_key',
        consumer_secret: 'consumer_secret'
      )
      expect(policy.consumer_credential.key).to eq('consumer_key')
      expect(policy.consumer_credential.secret).to eq('consumer_secret')
    end

    it 'is nil if none supplied to class' do
      OAuthPolicy.consumer_credential = nil
      policy = OAuthPolicy.new
      expect(policy.consumer_credential).to be_nil
    end
  end

  describe '#token' do
    it 'uses class setting if available' do
      OAuthPolicy.token = OAuthCredential.new 'xxx', 'xxx'
      policy = OAuthPolicy.new
      expect(policy.token.key).to eq('xxx')
      expect(policy.token.secret).to eq('xxx')
    end

    it 'is built from given oauth_token and oauth_token_secret' do
      policy = OAuthPolicy.new(
        oauth_token: 'oauth_token',
        oauth_token_secret: 'oauth_token_secret'
      )
      expect(policy.token.key).to eq('oauth_token')
      expect(policy.token.secret).to eq('oauth_token_secret')
    end

    it 'is an empty token if no oauth credentials supplied' do
      policy = OAuthPolicy.new
      expect(policy.token).to be_nil
    end
  end

  context '2-legged' do
    it 'adds an authorization header' do
      uri = Addressable::URI.parse('https://xxx/')

      request = Request.new :get, uri

      OAuthPolicy.token = OAuthCredential.new 'token', nil

      authorized_request = OAuthPolicy.authorize request

      expect(authorized_request.headers.keys).to include 'Authorization'
    end

    it 'preserves query parameters' do
      uri = Addressable::URI.parse('https://xxx/?name=Riccardo')
      request = Request.new :get, uri

      allow(Clock)
        .to receive(:timestamp)
        .and_return '1327048592'

      allow(Nonce)
        .to receive(:next)
        .and_return 'b94ff2bf7f0a5e87a326064ae1dbb18f'

      OAuthPolicy.consumer_credential = OAuthCredential.new 'consumer_key', 'consumer_secret'
      OAuthPolicy.token               = OAuthCredential.new 'token', nil

      authorized_request = OAuthPolicy.authorize request

      the_query_parameters = Addressable::URI.parse(authorized_request.uri).query_values
      expect(the_query_parameters).to eq({'name' => 'Riccardo'})
    end

    it 'adds the correct signature as part of authorization header' do
      allow(Clock)
        .to receive(:timestamp)
        .and_return '1327048592'

      allow(Nonce)
        .to receive(:next)
        .and_return 'b94ff2bf7f0a5e87a326064ae1dbb18f'

      OAuthPolicy.consumer_credential = OAuthCredential.new 'consumer_key', 'consumer_secret'
      OAuthPolicy.token               = OAuthCredential.new 'token', nil

      request = Request.new :get, Addressable::URI.parse('http://xxx/')

      authorized_request = OAuthPolicy.authorize request

      expect(authorized_request.headers['Authorization']).to match(/oauth_signature="TVNk%2FCs03FHqutDUqn05%2FDkvVek%3D"/)
    end

    it 'adds correct signature for uri with parameters' do
      allow(Clock)
        .to receive(:timestamp)
        .and_return '1327351010'

      allow(Nonce)
        .to receive(:next)
        .and_return 'f5474aaf44ca84df0b09870044f91c69'

      OAuthPolicy.consumer_credential = OAuthCredential.new 'consumer_key', 'consumer_secret'
      OAuthPolicy.token               = OAuthCredential.new 'token', nil

      request = Request.new :get, Addressable::URI.parse('http://xxx/?a=b')

      authorized_request = OAuthPolicy.authorize request

      expect(authorized_request.headers['Authorization']).to match(/oauth_signature="DprU1bdbNdJQ40UhD4n7wRR9jts%3D"/)
    end

    it 'fails if consumer_credential is unset' do
      OAuthPolicy.consumer_credential = nil

      request = Request.new :get, Addressable::URI.parse('http://xxx/')

      expect { OAuthPolicy.authorize request }.to raise_error 'The consumer_credential has not been supplied.'
    end

    it 'can sign with token' do
      allow(Clock)
        .to receive(:timestamp)
        .and_return '1327360530'

      allow(Nonce)
        .to receive(:next)
        .and_return '4f610cb28e7aa8711558de5234af1f0e'

      OAuthPolicy.consumer_credential = OAuthCredential.new 'consumer_key', 'consumer_secret'
      OAuthPolicy.token  = OAuthCredential.new 'token_key', 'token_secret'

      request = Request.new :get, Addressable::URI.parse('http://xxx/')

      authorized_request = OAuthPolicy.authorize request

      expect(authorized_request.headers['Authorization']).to match(/oauth_signature="1Boj4fo6KiXA4xGD%2BKF5QOD36PI%3D"/)
    end

    it 'adds correct signature for https uri'
    it 'adds correct signature for verbs other than get'
  end
end
