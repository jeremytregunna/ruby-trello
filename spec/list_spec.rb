require 'spec_helper'

module Trello
  describe List do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/lists/abcdef123456789123456789").and_return JSON.generate(lists_details.first)
      Client.stub(:get).with("/boards/abcdef123456789123456789").and_return JSON.generate(boards_details.first)

      @list = List.find("abcdef123456789123456789")
    end

    context "fields" do
      it "gets its id" do
        @list.id.should == lists_details.first['id']
      end

      it "gets its name" do
        @list.name.should == lists_details.first['name']
      end

      it "knows if it is open or closed" do
        @list.closed.should == lists_details.first['closed']
      end

      it "has a board" do
        @list.board.should == Board.new(boards_details.first)
      end
    end

    context "actions" do
      it "has a list of actions" do
        Client.stub(:get).with("/lists/abcdef123456789123456789/actions", { :filter => :all }).and_return actions_payload
        @list.actions.count.should be > 0
      end
    end

    context "cards" do
      it "has a list of cards" do
        Client.stub(:get).with("/lists/abcdef123456789123456789/cards", { :filter => :open }).and_return cards_payload
        @list.cards.count.should be > 0
      end
    end

    it "is not closed" do
      @list.closed?.should_not be_true
    end
  end
end
