require 'spec_helper'

module Trello
  describe Action do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_request(:get, "https://api.trello.com/1/actions/4ee2482134a81a757a08af47?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => JSON.generate(actions_details.first))

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
    end

    context "boards" do
      it "has a board" do
        stub_trello_request!(:get, "/actions/4ee2482134a81a757a08af47/board?", nil, JSON.generate(boards_details.first))
        @action.board.should_not be_nil
      end
    end

    context "card" do
      it "has a card" do
        stub_trello_request!(:get, "/actions/4ee2482134a81a757a08af47/card?", nil, JSON.generate(cards_details.first))
        @action.card.should_not be_nil
      end
    end

    context "list" do
      it "has a list of lists" do
        stub_trello_request!(:get, "/actions/4ee2482134a81a757a08af47/list?", nil, JSON.generate(lists_details.first))
        @action.list.should_not be_nil
      end
    end

    context "member creator" do
      it "knows its member creator" do
        stub_trello_request!(:get, "/members/abcdef123456789123456789?", nil, user_payload)
        @action.member_creator.should_not be_nil
      end
    end
  end
end