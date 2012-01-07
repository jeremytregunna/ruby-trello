require 'spec_helper'

module Trello
  describe Client do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_oauth!
    end

    context 'keys' do
      after do
        Client.public_key = 'dummy'
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