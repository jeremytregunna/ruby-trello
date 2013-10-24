require 'spec_helper'

module Trello
  describe Token do
    include Helpers

    let(:token) { client.find(:token, '1234') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with('/tokens/1234', {}).and_return token_payload
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to Trello.client#find' do
        client.should_receive(:find).with(:token, '1234', {:webhooks => true})
        Token.find('1234')
      end

      it 'is equivalent to client#find' do
        Token.find('1234', {}).should eq(token)
      end
    end

    context 'attributes' do
      it 'has an id' do
        token.id.should == '4f2c10c7b3eb95a45b294cd5'
      end

      it 'gets its created_at date' do
        token.created_at.should == Time.iso8601('2012-02-03T16:52:23.661Z')
      end

      it 'has a permission grant' do
        token.permissions.count.should be 3
      end
    end

    context 'members' do
      it 'retrieves the member who authorized the token' do
        client.stub(:get).with('/members/abcdef123456789123456789', {}).and_return user_payload
        Trello.client.stub(:get).with('/members/abcdef123456789123456789', {}).and_return user_payload
        client.stub(:get).with('/tokens/1234', {}).and_return token_payload
        token.member.should == Member.find('abcdef123456789123456789')
      end
    end
  end
end
