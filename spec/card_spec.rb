require 'spec_helper'

module Trello
  describe Card do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_request(:get, "https://api.trello.com/1/cards/abcdef123456789123456789?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => Yajl::Encoder.encode(cards_details.first))

      @card = Card.find('abcdef123456789123456789')
    end

    context "fields" do
      it "gets its id" do
        @card.id.should_not be_nil
      end

      it "gets its name" do
        @card.name.should_not be_nil
      end

      it "gets its description" do
        @card.description.should_not be_nil
      end

      it "knows if it is open or closed" do
        @card.closed.should_not be_nil
      end

      it "gets its url" do
        @card.url.should_not be_nil
      end
    end

    context "boards" do
      it "has a board" do
        stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => Yajl::Encoder.encode(boards_details.first))

        @card.board.should_not be_nil
      end
    end

    context "members" do
      it "has a list of members" do
        stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => Yajl::Encoder.encode(boards_details.first))
        stub_request(:get, "https://api.trello.com/1/members/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => user_payload)

        @card.board.should_not be_nil
        @card.members.should_not be_nil
      end
    end
  end
end