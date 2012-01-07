require 'spec_helper'

module Trello
  describe Client do
    context 'keys' do
      before(:each) do
        Client.public_key = TEST_PUBLIC_KEY
        Client.secret     = TEST_SECRET
      end

      it 'throws an error if the public key is ommitted' do
        Client.public_key = ''
        lambda { Client.query('/1/members/me') }.should raise_error(Client::EnterYourPublicKey)
      end

      it 'throws an error if the secret is ommitted' do
        Client.secret = ''
        lambda { Client.query('/1/members/me') }.should raise_error(Client::EnterYourSecret)
      end

      it 'does not throw any errors' do
        lambda { Client.query('/1/members/me') }.should_not raise_error
      end
    end
  end
end