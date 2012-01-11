require 'spec_helper'

module Trello
  describe List do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_trello_request!(:get, "/lists/abcdef123456789123456789?", nil, JSON.generate(lists_details.first))
      stub_trello_request!(:get, "/boards/abcdef123456789123456789?", nil, JSON.generate(boards_details.first))

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

    context "cards" do
      it "has a list of cards" do
        stub_trello_request!(:get, "/lists/abcdef123456789123456789/cards?", { :filter => :open }, cards_payload)
        @list.cards.count.should be > 0
      end
    end
  end
end