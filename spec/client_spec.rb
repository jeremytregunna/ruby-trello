require 'spec_helper'

module Trello
  describe Client do
    include Helpers

    before(:all) do
      stub_request(:get, "https://api.trello.com/1/members/me?").
         with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth oauth_consumer_key="dummy", oauth_nonce="HWHDPnob0bDB5pXykxXSgV0RGNXaRkVHevuGNfVA", oauth_signature="Lh9bMps8Bl84gGFdBtUD8skXluo%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1325965269", oauth_version="1.0"', 'User-Agent'=>'OAuth gem v0.4.5'}).
         to_return(:status => 200, :headers => {}, :body => Yajl::Encoder.encode(user_details))
    end

    context 'keys' do
      before(:each) do
        Client.public_key = 'dummy'
        Client.secret     = 'dummy'
      end

      it 'throws an error if the public key is ommitted' do
        Client.public_key = ''
        lambda { Client.query('/1/members/me') }.should raise_error(Client::EnterYourPublicKey)
      end

      it 'throws an error if the secret is ommitted' do
        Client.secret = ''
        lambda { Client.query('/1/members/me') }.should raise_error(Client::EnterYourSecret)
      end
    end
  end
end