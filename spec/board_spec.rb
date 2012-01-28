require 'spec_helper'

module Trello
  describe Board do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/boards/abcdef123456789123456789").
        and_return JSON.generate(boards_details.first)

      @board = Board.find('abcdef123456789123456789')
    end

    context "fields" do
      it "gets an id" do
        @board.id.should_not be_nil
      end

      it "gets a name" do
        @board.name.should_not be_nil
      end

      it "gets the description" do
        @board.description.should_not be_nil
      end

      it "knows if it is closed or open" do
        @board.closed.should_not be_nil
      end

      it "gets its url" do
        @board.url.should_not be_nil
      end
    end

    context "actions" do
      it "has a list of actions" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/actions").
          and_return actions_payload

        @board.actions.count.should be > 0
      end
    end

    context "cards" do
      it "gets its list of cards" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/cards").
          and_return cards_payload

        @board.cards.count.should be > 0
      end
    end

    context "lists" do
      it "has a list of lists" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/lists", hash_including(:filter => :open)).
          and_return lists_payload

        @board.lists.count.should be > 0
      end
    end

    context "members" do
      it "has a list of members" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/members", hash_including(:filter => :all)).
          and_return JSON.generate([user_details])

        @board.members.count.should be > 0
      end
    end

    context "organization" do
      it "belongs to an organization" do
        Client.stub(:get).with("/organizations/abcdef123456789123456789").
          and_return JSON.generate(orgs_details.first)

        @board.organization.should_not be_nil
      end
    end

    it "is not closed" do
      @board.closed?.should_not be_true
    end
  end
  
  describe "Repository" do
    it "creates a new board with whatever attributes are supplied " do
      expected_attributes = { :name => "Any new board name", :description => "Any new board desription" }
      Client.should_receive(:post).with(anything, expected_attributes)

      Board.create expected_attributes
    end

    it "at least name is required"
  end
end
