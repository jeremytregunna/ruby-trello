require 'spec_helper'

module Trello
  describe Token do
    include Helpers

    let(:token) { client.find(:token, '1234') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with('/tokens/1234', {})
        .and_return token_payload
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to Trello.client#find' do
        expect(client)
          .to receive(:find)
          .with(:token, '1234', {webhooks: true})

        Token.find('1234')
      end

      it 'is equivalent to client#find' do
        expect(Token.find('1234', {})).to eq(token)
      end
    end

    context 'attributes' do
      it 'has an id' do
        expect(token.id).to eq '4f2c10c7b3eb95a45b294cd5'
      end

      it 'gets its created_at date' do
        expect(token.created_at).to eq Time.iso8601('2012-02-03T16:52:23.661Z')
      end

      it 'has a permission grant' do
        expect(token.permissions.count).to eq 3
      end
    end

    context 'members' do
      before do
        allow(client)
          .to receive(:get)
          .with('/members/abcdef123456789123456789', {})
          .and_return user_payload

        allow(Trello.client)
          .to receive(:get)
          .with('/members/abcdef123456789123456789', {})
          .and_return user_payload

        allow(client)
          .to receive(:get)
          .with('/tokens/1234', {})
          .and_return token_payload
      end

      it 'retrieves the member who authorized the token' do
        expect(token.member).to eq Member.find('abcdef123456789123456789')
      end
    end
  end
end
