require 'spec_helper'

module Trello
  describe List do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_request(:get, "https://api.trello.com/1/lists/abcdef123456789123456789?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => JSON.generate(lists_details.first))
      stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => JSON.generate(boards_details.first))

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
        @list.cards.count.should be > 0
      end
    end
  end
end