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
        to_return(:status => 200, :headers => {}, :body => JSON.generate(cards_details.first))

      @card = Card.find('abcdef123456789123456789')
    end

    context "creating" do
      it "creates a new record" do
        card = Card.new(cards_details.first)
        card.should be_valid
      end

      it 'must not be valid if not given a name' do
        card = Card.new('idList' => lists_details.first['id'])
        card.should_not be_valid
      end

      it 'must not be valid if not given a list id' do
        card = Card.new('name' => lists_details.first['name'])
        card.should_not be_valid
      end

      it 'creates a new record and saves it on Trello' do
        payload = {
          :name    => 'Test Card',
          :desc    => '',
        }
        stub_trello_request!(:post, '/cards', payload.merge(:idList => lists_details.first['id']))
        card = Card.create(payload.merge(:list_id => lists_details.first['id']))
        card.should == ''
      end
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

    context "actions" do
      it "has a list of actions" do
        stub_trello_request!(:get, "/cards/abcdef123456789123456789/actions?", nil, actions_payload)
        @card.actions.count.should be > 0
      end
    end

    context "boards" do
      it "has a board" do
        stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => JSON.generate(boards_details.first))

        @card.board.should_not be_nil
      end
    end

    context "checklists" do
      it "has a list of checklists" do
        stub_trello_request!(:get, "/cards/abcdef123456789123456789/checklists?", { :filter => :all }, checklists_payload)
        @card.checklists.count.should be > 0
      end
    end

    context "list" do
      it 'has a list' do
        stub_trello_request!(:get, "/lists/abcdef123456789123456789?", nil, JSON.generate(lists_details.first))
        @card.list.should_not be_nil
      end
    end

    context "members" do
      it "has a list of members" do
        stub_request(:get, "https://api.trello.com/1/boards/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => JSON.generate(boards_details.first))
        stub_request(:get, "https://api.trello.com/1/members/abcdef123456789123456789?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => user_payload)

        @card.board.should_not be_nil
        @card.members.should_not be_nil
      end
    end

    context "comments" do
      it "posts a comment" do
        stub_trello_request!(:put, "/cards/abcdef123456789123456789/actions/comments", { :text => 'testing' })
        @card.add_comment("testing").should be_empty
      end
    end
  end
end