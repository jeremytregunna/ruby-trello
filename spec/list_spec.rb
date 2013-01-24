require 'spec_helper'

module Trello
  describe List do
    include Helpers

    before(:each) do
      Trello.client.stub(:get).with("/lists/abcdef123456789123456789").and_return JSON.generate(lists_details.first)
      Trello.client.stub(:get).with("/boards/abcdef123456789123456789").and_return JSON.generate(boards_details.first)

      @list = List.find("abcdef123456789123456789")
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"

        payload = {
          :name      => expected_new_name,
          :closed    => false
        }

        Trello.client.should_receive(:put).once.with("/lists/abcdef123456789123456789", payload)
        @list.name = expected_new_name
        @list.save
      end
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

      it "gets its position" do
        @list.pos.should == lists_details.first['pos']
      end
    end

    context "actions" do
      it "has a list of actions" do
        Trello.client.stub(:get).with("/lists/abcdef123456789123456789/actions", { :filter => :all }).and_return actions_payload
        @list.actions.count.should be > 0
      end
    end

    context "cards" do
      it "has a list of cards" do
        Trello.client.stub(:get).with("/lists/abcdef123456789123456789/cards", { :filter => :open }).and_return cards_payload
        @list.cards.count.should be > 0
      end
    end

    describe "#closed?" do
      it "returns the closed attribute" do
        @list.closed?.should_not be_true
      end
    end

    describe "#close" do
      it "updates the close attribute to true" do
        @list.close
        @list.closed.should be_true
      end
    end

    describe "#close!" do
      it "updates the close attribute to true and saves the list" do
        Trello.client.should_receive(:put).once.with("/lists/abcdef123456789123456789", {
          :name   => @list.name,
          :closed => true
        })

        @list.close!
      end
    end
  end
end
