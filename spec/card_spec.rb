require 'spec_helper'

module Trello
  describe Card do
    include Helpers

    let(:card) { client.find(:card, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/cards/abcdef123456789123456789", {}).
        and_return JSON.generate(cards_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:card, 'abcdef123456789123456789', {})
        Card.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        Card.find('abcdef123456789123456789').should eq(card)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

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
          :desc    => nil,
        }

        result = JSON.generate(cards_details.first.merge(payload.merge(:idList => lists_details.first['id'])))

        expected_payload = {:name => "Test Card", :desc => nil, :idList => "abcdef123456789123456789"}

        client.should_receive(:post).with("/cards", expected_payload).and_return result

        card = Card.create(cards_details.first.merge(payload.merge(:list_id => lists_details.first['id'])))

        card.class.should be Card
      end
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"

        payload = {
          :name      => expected_new_name,
        }

        client.should_receive(:put).once.with("/cards/abcdef123456789123456789", payload)

        card.name = expected_new_name
        card.save
      end
    end

    context "deleting" do
      it "deletes the card" do
        client.should_receive(:delete).with("/cards/#{card.id}")
        card.delete
      end
    end

    context "fields" do
      it "gets its id" do
        card.id.should_not be_nil
      end

      it "gets its short id" do
        card.short_id.should_not be_nil
      end

      it "gets its name" do
        card.name.should_not be_nil
      end

      it "gets its description" do
        card.desc.should_not be_nil
      end

      it "knows if it is open or closed" do
        card.closed.should_not be_nil
      end

      it "gets its url" do
        card.url.should_not be_nil
      end

      it "gets its last active date" do
        card.last_activity_date.should_not be_nil
      end
    end

    context "actions" do
      it "asks for all actions by default" do
        client.stub(:get).with("/cards/abcdef123456789123456789/actions", { :filter => :all }).and_return actions_payload
        card.actions.count.should be > 0
      end

      it "allows overriding the filter" do
        client.stub(:get).with("/cards/abcdef123456789123456789/actions", { :filter => :updateCard }).and_return actions_payload
        card.actions(:filter => :updateCard).count.should be > 0
      end
    end

    context "boards" do
      it "has a board" do
        client.stub(:get).with("/boards/abcdef123456789123456789", {}).and_return JSON.generate(boards_details.first)
        card.board.should_not be_nil
      end
    end

    context "checklists" do
      it "has a list of checklists" do
        client.stub(:get).with("/cards/abcdef123456789123456789/checklists", { :filter => :all }).and_return checklists_payload
        card.checklists.count.should be > 0
      end
    end

    context "list" do
      it 'has a list' do
        client.stub(:get).with("/lists/abcdef123456789123456789", {}).and_return JSON.generate(lists_details.first)
        card.list.should_not be_nil
      end

      it 'can be moved to another list' do
        other_list = double(:id => '987654321987654321fedcba')
        payload = {:value => other_list.id}
        client.should_receive(:put).with("/cards/abcdef123456789123456789/idList", payload)
        card.move_to_list(other_list)
      end

      it 'should not be moved if new list is identical to old list' do
        other_list = double(:id => 'abcdef123456789123456789')
        payload = { :value => other_list.id }
        client.should_not_receive(:put)
        card.move_to_list(other_list)
      end

      it 'can be moved to another board' do
        other_board = double(:id => '987654321987654321fedcba')
        payload = {:value => other_board.id}
        client.should_receive(:put).with("/cards/abcdef123456789123456789/idBoard", payload)
        card.move_to_board(other_board)
      end

      it 'can be moved to a list on another board' do
        other_board = double(:id => '987654321987654321fedcba')
        other_list = double(:id => '987654321987654321aalist')
        payload = {:value => other_board.id, :idList => other_list.id}
        client.should_receive(:put).with("/cards/abcdef123456789123456789/idBoard", payload)
        card.move_to_board(other_board, other_list)
      end

      it 'should not be moved if new board is identical with old board', :focus => true do
        other_board = double(:id => 'abcdef123456789123456789')
        client.should_not_receive(:put)
        card.move_to_board(other_board)
      end
    end

    context "members" do
      it "has a list of members" do
        client.stub(:get).with("/boards/abcdef123456789123456789", {}).and_return JSON.generate(boards_details.first)
        client.stub(:get).with("/members/abcdef123456789123456789").and_return user_payload

        card.board.should_not be_nil
        card.members.should_not be_nil
      end

      it "allows a member to be added to a card" do
        new_member = double(:id => '4ee7df3ce582acdec80000b2')
        payload = {
          :value => new_member.id
        }
        client.should_receive(:post).with("/cards/abcdef123456789123456789/members", payload)
        card.add_member(new_member)
      end

      it "allows a member to be removed from a card" do
        existing_member = double(:id => '4ee7df3ce582acdec80000b2')
        client.should_receive(:delete).with("/cards/abcdef123456789123456789/members/#{existing_member.id}")
        card.remove_member(existing_member)
      end
    end

    context "comments" do
      it "posts a comment" do
        client.should_receive(:post).
          with("/cards/abcdef123456789123456789/actions/comments", { :text => 'testing' }).
          and_return JSON.generate(boards_details.first)

        card.add_comment "testing"
      end
    end

    context "labels" do
      it "can retrieve labels" do
        client.stub(:get).with("/cards/abcdef123456789123456789/labels").
          and_return label_payload
        labels = card.labels
        labels.size.should == 2

        labels[0].color.should == 'yellow'
        labels[0].name.should == 'iOS'

        labels[1].color.should == 'purple'
        labels[1].name.should == 'Issue or bug'
      end

      it "can add a label" do
        client.stub(:post).with("/cards/abcdef123456789123456789/labels", { :value => 'green' }).
          and_return "not important"
        card.add_label('green')
        card.errors.should be_empty
      end

      it "can remove a label" do
        client.stub(:delete).with("/cards/abcdef123456789123456789/labels/green").
          and_return "not important"
        card.remove_label('green')
        card.errors.should be_empty
      end

      it "throws an error when trying to add a label with an unknown colour" do
        client.stub(:post).with("/cards/abcdef123456789123456789/labels", { :value => 'green' }).
          and_return "not important"
        card.add_label('mauve')
        card.errors.full_messages.to_sentence.should == "Label colour 'mauve' does not exist"
      end

      it "throws an error when trying to remove a label with an unknown colour" do
        client.stub(:delete).with("/cards/abcdef123456789123456789/labels/mauve").
          and_return "not important"
        card.remove_label('mauve')
        card.errors.full_messages.to_sentence.should == "Label colour 'mauve' does not exist"
      end
    end

    context "attachments" do
      it "can add an attachment" do
        f = File.new('spec/list_spec.rb', 'r')
        client.stub(:get).with("/cards/abcdef123456789123456789/attachments").and_return attachments_payload
        client.stub(:post).with("/cards/abcdef123456789123456789/attachments",
              { :file => f, :name => ''  }).
              and_return "not important"

        card.add_attachment(f)

        card.errors.should be_empty
      end

      it "can list the existing attachments with correct fields" do
        client.stub(:get).with("/boards/abcdef123456789123456789", {}).and_return JSON.generate(boards_details.first)
        client.stub(:get).with("/cards/abcdef123456789123456789/attachments").and_return attachments_payload

        card.board.should_not be_nil
        card.attachments.should_not be_nil
        first_attachment = card.attachments.first
        first_attachment.id.should == attachments_details[0]["id"]
        first_attachment.name.should == attachments_details[0]["name"]
        first_attachment.url.should == attachments_details[0]["url"]
        first_attachment.bytes.should == attachments_details[0]["bytes"]
        first_attachment.member_id.should == attachments_details[0]["idMember"]
        first_attachment.date.should == Time.parse(attachments_details[0]["date"])
        first_attachment.is_upload.should == attachments_details[0]["isUpload"]
        first_attachment.mime_type.should == attachments_details[0]["mimeType"]
      end

      it "can remove an attachment" do
        client.stub(:delete).with("/cards/abcdef123456789123456789/attachments/abcdef123456789123456789").
          and_return "not important"
        client.stub(:get).with("/cards/abcdef123456789123456789/attachments").and_return attachments_payload

        card.remove_attachment(card.attachments.first)
        card.errors.should be_empty
      end
    end

    describe "#closed?" do
      it "returns the closed attribute" do
        card.closed?.should_not be_true
      end
    end

    describe "#close" do
      it "updates the close attribute to true" do
        card.close
        card.closed.should be_true
      end
    end

    describe "#close!" do
      it "updates the close attribute to true and saves the list" do
        payload = {
          :closed    => true,
        }

        client.should_receive(:put).once.with("/cards/abcdef123456789123456789", payload)

        card.close!
      end
    end

  end
end
