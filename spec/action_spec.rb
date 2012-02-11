require 'spec_helper'

module Trello
  describe Action do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/actions/4ee2482134a81a757a08af47").
        and_return JSON.generate(actions_details.first)

      @action = Action.find('4ee2482134a81a757a08af47')
    end

    context "fields" do
      before(:all) do
        @detail = actions_details.first
      end

      it "gets its id" do
        @action.id.should == @detail['id']
      end

      it "gets its type" do
        @action.type.should == @detail['type']
      end

      it "has the same data" do
        @action.data.should == @detail['data']
      end

      it "gets the date" do
        @action.date.utc.iso8601.should == @detail['date']
      end
    end

    context "boards" do
      it "has a board" do
        Client.stub(:get).with("/actions/4ee2482134a81a757a08af47/board").
          and_return JSON.generate(boards_details.first)

        @action.board.should_not be_nil
      end
    end

    context "card" do
      it "has a card" do
        Client.stub(:get).with("/actions/4ee2482134a81a757a08af47/card").
          and_return JSON.generate(cards_details.first)
        
        @action.card.should_not be_nil
      end
    end

    context "list" do
      it "has a list of lists" do
        Client.stub(:get).with("/actions/4ee2482134a81a757a08af47/list").
          and_return JSON.generate(lists_details.first)

        @action.list.should_not be_nil
      end
    end

    context "member creator" do
      it "knows its member creator" do
        Client.stub(:get).with("/members/abcdef123456789123456789").and_return user_payload

        @action.member_creator.should_not be_nil
      end
    end
  end
end
