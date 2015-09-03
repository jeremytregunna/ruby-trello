require 'spec_helper'

module Trello
  describe Action do
    include Helpers

    let(:client)  { Client.new }
    let(:action)  { client.find(:action, '4ee2482134a81a757a08af47') }

    before do
      allow(client)
        .to receive(:get)
        .with('/actions/4ee2482134a81a757a08af47', {})
        .and_return JSON.generate(actions_details.first)
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to Trello.client#find' do
        expect(client)
          .to receive(:find)
          .with(:action, '4ee2482134a81a757a08af47', {})

        Action.find('4ee2482134a81a757a08af47')
      end

      it do
        expect(Action.find('4ee2482134a81a757a08af47')).to eq(action)
      end
    end

    context 'search' do
      let(:client) { Trello.client }
      let(:payload) { JSON.generate({ "cards" => cards_details }) }

      it "searches and get back a card object" do
        expect(client)
          .to receive(:get)
          .with("/search/", { query: "something"})
          .and_return payload

        expect(Action.search("something"))
          .to eq({ "cards" => cards_details.jsoned_into(Card) })
      end
    end

    context 'fields' do
      let(:detail) { actions_details.first }

      it 'gets its id' do
        expect(action.id).to eq detail['id']
      end

      it 'gets its type' do
        expect(action.type).to eq detail['type']
      end

      it 'has the same data' do
        expect(action.data).to eq detail['data']
      end

      it 'gets the date' do
        expect(action.date.utc.iso8601).to eq detail['date']
      end
    end

    context 'boards' do
      let(:payload) { JSON.generate(boards_details.first) }

      before do
        allow(client)
          .to receive(:get)
          .with('/actions/4ee2482134a81a757a08af47/board')
          .and_return payload
      end

      it 'has a board' do
        expect(action.board).to_not be_nil
      end
    end


    context 'card' do
      let(:payload) { JSON.generate(cards_details.first) }

      before do
        allow(client)
          .to receive(:get)
          .with('/actions/4ee2482134a81a757a08af47/card')
          .and_return payload
      end

      it 'has a card' do
        expect(action.card).to_not be_nil
      end
    end

    context 'list' do
      let(:payload) { JSON.generate(lists_details.first) }

      before do
        allow(client)
          .to receive(:get)
          .with('/actions/4ee2482134a81a757a08af47/list')
          .and_return payload
      end

      it 'has a list of lists' do
        expect(action.list).to_not be_nil
      end
    end

    context 'member creator' do

      before do
        allow(client)
          .to receive(:get)
          .with('/members/abcdef123456789123456789', {})
          .and_return user_payload
      end

      it 'knows its member creator' do
        expect(action.member_creator).to_not be_nil
      end
    end
  end
end
