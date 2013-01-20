require 'spec_helper'

module Trello
  describe Action do
    include Helpers

    let(:action) { client.find(:action, '4ee2482134a81a757a08af47') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/actions/4ee2482134a81a757a08af47").
        and_return JSON.generate(actions_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:action, '4ee2482134a81a757a08af47')
        Action.find('4ee2482134a81a757a08af47')
      end

      it "is equivalent to client#find" do
        Action.find('4ee2482134a81a757a08af47').should eq(action)
      end
    end

    context "fields" do
      let(:detail) { actions_details.first }

      it "gets its id" do
        action.id.should == detail['id']
      end

      it "gets its type" do
        action.type.should == detail['type']
      end

      it "has the same data" do
        action.data.should == detail['data']
      end

      it "gets the date" do
        action.date.utc.iso8601.should == detail['date']
      end
    end

    context "boards" do
      it "has a board" do
        client.stub(:get).with("/actions/4ee2482134a81a757a08af47/board").
          and_return JSON.generate(boards_details.first)

        action.board.should_not be_nil
      end
    end

    context "card" do
      it "has a card" do
        client.stub(:get).with("/actions/4ee2482134a81a757a08af47/card").
          and_return JSON.generate(cards_details.first)

        action.card.should_not be_nil
      end
    end

    context "list" do
      it "has a list of lists" do
        client.stub(:get).with("/actions/4ee2482134a81a757a08af47/list").
          and_return JSON.generate(lists_details.first)

        action.list.should_not be_nil
      end
    end

    context "member creator" do
      it "knows its member creator" do
        client.stub(:get).with("/members/abcdef123456789123456789").and_return user_payload

        action.member_creator.should_not be_nil
      end
    end
  end
end
