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

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"
        expected_resource = "/card/#{@card.id}/name"
        payload = {
          :name      => expected_new_name,
          :desc      => "Awesome things are awesome.",
          :due       => nil,
          :closed    => false,
          :idList    => "abcdef123456789123456789",
          :idBoard   => "abcdef123456789123456789",
          :idMembers => ["abcdef123456789123456789"]
        }

        Client.should_receive(:put).once.with("/cards/abcdef123456789123456789", payload)
        card = @card.dup
        card.name = expected_new_name
        card.save
      end
    end

    context "fields" do
      it "gets its id" do
        @card.id.should_not be_nil
      end

      it "gets its short id" do
        @card.short_id.should_not be_nil
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
      it "asks for all actions by default" do
        Client.stub(:get).with("/cards/abcdef123456789123456789/actions", { :filter => :all }).and_return actions_payload
        @card.actions.count.should be > 0
      end

      it "allows overriding the filter" do
        Client.stub(:get).with("/cards/abcdef123456789123456789/actions", { :filter => :updateCard }).and_return actions_payload
        @card.actions(:filter => :updateCard).count.should be > 0
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
        Client.should_receive(:post).
          with("/cards/abcdef123456789123456789/actions/comments", { :text => 'testing' }).
          and_return JSON.generate(boards_details.first)
        
        @card.add_comment "testing"
      end
    end

    context "labels" do
      it "can retrieve labels" do
        Client.stub(:get).with("/cards/abcdef123456789123456789/labels").
          and_return label_payload
        labels = @card.labels
        labels.size.should == 2

        labels[0].color.should == 'yellow'
        labels[0].name.should == 'iOS'

        labels[1].color.should == 'purple'
        labels[1].name.should == 'Issue or bug'
      end

      it "can add a label" do
        Client.stub(:post).with("/cards/abcdef123456789123456789/labels", { :value => 'green' }).
          and_return "not important"
        @card.add_label('green')
        @card.errors.should be_empty
      end

      it "can remove a label" do
        Client.stub(:delete).with("/cards/abcdef123456789123456789/labels/green").
          and_return "not important"
        @card.remove_label('green')
        @card.errors.should be_empty
      end

      it "throws an error when trying to add a label with an unknown colour" do
        Client.stub(:post).with("/cards/abcdef123456789123456789/labels", { :value => 'green' }).
          and_return "not important"
        @card.add_label('mauve')
        @card.errors.full_messages.to_sentence.should == "Label colour 'mauve' does not exist"
      end

      it "throws an error when trying to remove a label with an unknown colour" do
        Client.stub(:delete).with("/cards/abcdef123456789123456789/labels/mauve").
          and_return "not important"
        @card.remove_label('mauve')
        @card.errors.full_messages.to_sentence.should == "Label colour 'mauve' does not exist"
      end
    end
  end
end
