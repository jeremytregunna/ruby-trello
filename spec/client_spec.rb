require 'spec_helper'

module Trello
  describe Client do
    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    context 'keys' do
      after do
        Client.public_key = 'dummy'
      end

      it 'throws an error if the public key is ommitted' do
        Client.public_key = ''
        lambda { Client.send(:consumer) }.should raise_error(Client::EnterYourPublicKey)
      end

      after do
        Client.secret = 'dummy'
      end

      it 'throws an error if the secret is ommitted' do
        Client.secret = ''
        lambda { Client.send(:consumer) }.should raise_error(Client::EnterYourSecret)
      end
    end
  end
end