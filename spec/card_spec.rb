require 'spec_helper'

module Trello
  describe Card do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/cards/abcdef123456789123456789").
        and_return JSON.generate(cards_details.first)

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

      it 'creates a new record and saves it on Trello', :refactor => true do
        payload = {
          :name    => 'Test Card',
          :desc    => '',
        }
 
        result = JSON.generate(cards_details.first.merge(payload.merge(:idList => lists_details.first['id'])))

        expected_payload = {:name => "Test Card", :desc => nil, :idList => "abcdef123456789123456789"}

        Client.should_receive(:post).with("/cards", expected_payload).and_return result

        card = Card.create(cards_details.first.merge(payload.merge(:list_id => lists_details.first['id'])))
        
        card.class.should be Card
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
        Client.stub(:get).with("/cards/abcdef123456789123456789/actions").and_return actions_payload
        @card.actions.count.should be > 0
      end
    end

    context "boards" do
      it "has a board" do
        Client.stub(:get).with("/boards/abcdef123456789123456789").and_return JSON.generate(boards_details.first)
        @card.board.should_not be_nil
      end
    end

    context "checklists" do
      it "has a list of checklists" do
        Client.stub(:get).with("/cards/abcdef123456789123456789/checklists", { :filter => :all }).and_return checklists_payload
        @card.checklists.count.should be > 0
      end
    end

    context "list" do
      it 'has a list' do
        Client.stub(:get).with("/lists/abcdef123456789123456789").and_return JSON.generate(lists_details.first)
        @card.list.should_not be_nil
      end
    end

    context "members" do
      it "has a list of members" do
        Client.stub(:get).with("/boards/abcdef123456789123456789").and_return JSON.generate(boards_details.first)
        Client.stub(:get).with("/members/abcdef123456789123456789").and_return user_payload

        @card.board.should_not be_nil
        @card.members.should_not be_nil
      end
    end

    context "comments" do
      it "posts a comment" do
        Client.should_receive(:put).
          with("/cards/abcdef123456789123456789/actions/comments", { :text => 'testing' }).
          and_return JSON.generate(boards_details.first)
        
        @card.add_comment "testing"
      end
    end
  end
end
