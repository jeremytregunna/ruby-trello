require 'spec_helper'

module Trello
  describe Board do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => JSON.generate(boards_details.first))

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
        stub_trello_request!(:get, "/boards/abcdef123456789123456789/actions?", nil, actions_payload)
        @board.actions.count.should be > 0
      end
    end

    context "cards" do
      it "gets its list of cards" do
        stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789/cards?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => cards_payload)

        @board.cards.count.should be > 0
      end
    end

    context "lists" do
      it "has a list of lists" do
        stub_trello_request!(:get, "/boards/abcdef123456789123456789/lists?", { :filter => :open }, lists_payload)
        @board.lists.count.should be > 0
      end
    end

    context "members" do
      it "has a list of members" do
        stub_trello_request!(:get, "/boards/abcdef123456789123456789/members?", { :filter => :all }, JSON.generate([user_details]))
        @board.members.count.should be > 0
      end
    end

    context "organization" do
      it "belongs to an organization" do
        stub_trello_request!(:get, "/organizations/abcdef123456789123456789?", nil, JSON.generate(orgs_details.first))
        @board.organization.should_not be_nil
      end
    end

    it "is not closed" do
      @board.closed?.should_not be_true
    end
  end
end