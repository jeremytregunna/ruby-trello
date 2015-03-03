require 'spec_helper'

module Trello
  describe Label do
    include Helpers

    let(:label) { client.find(:label, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/labels/abcdef123456789123456789", {}).
      and_return JSON.generate(label_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:label, 'abcdef123456789123456789', {})
        Label.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        Label.find('abcdef123456789123456789').should eq(label)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it "creates a new record" do
        label = Label.new(label_details.first)
        label.should be_valid
      end

      it 'must not be valid if not given a name' do
        label = Label.new('idBoard' => lists_details.first['board_id'])
        label.should_not be_valid
      end

      it 'must not be valid if not given a board id' do
        label = Label.new('name' => lists_details.first['name'])
        label.should_not be_valid
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        payload = {
          name: 'Test Label',
          board_id: 'abcdef123456789123456789',
        }

        result = JSON.generate(cards_details.first.merge(payload.merge(idBoard: boards_details.first['id'])))

        expected_payload = {name: "Test Label", color: nil, idBoard: "abcdef123456789123456789" }

        client.should_receive(:post).with("/labels", expected_payload).and_return result

        label = Label.create(label_details.first.merge(payload.merge(board_id: boards_details.first['id'])))

        label.class.should be Label
      end
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"

        payload = {
          name: expected_new_name,
        }

        client.should_receive(:put).once.with("/labels/abcdef123456789123456789", payload)

        label.name = expected_new_name
        label.save
      end

      it "updating color does a put on the correct resource with the correct value" do
        expected_new_color = "purple"

        payload = {
          color: expected_new_color,
        }

        client.should_receive(:put).once.with("/labels/abcdef123456789123456789", payload)

        label.color = expected_new_color
        label.save
      end

      it "can update with any valid color" do
        %w(green yellow orange red purple blue sky lime pink black).each do |color|
          client.stub(:put).with("/labels/abcdef123456789123456789", {color: color}).
            and_return "not important"
          label.color = color
          label.save
          expect(label.errors).to be_empty
        end
      end

      it "throws an error when trying to update a label with an unknown colour" do
        client.stub(:put).with("/labels/abcdef123456789123456789", {}).
          and_return "not important"
        label.color = 'mauve'
        label.save
        expect(label.errors.full_messages.to_sentence).to eq("Label color 'mauve' does not exist")
      end
    end

    context "deleting" do
      it "deletes the label" do
        client.should_receive(:delete).with("/labels/#{label.id}")
        label.delete
      end
    end

    context "fields" do
      it "gets its id" do
        label.id.should_not be_nil
      end

      it "gets its name" do
        label.name.should_not be_nil
      end

      it "gets its usage" do
        label.uses.should_not be_nil
      end

      it "gets its color" do
        label.color.should_not be_nil
      end
    end

    context "boards" do
      it "has a board" do
        client.stub(:get).with("/boards/abcdef123456789123456789", {}).and_return JSON.generate(boards_details.first)
        label.board.should_not be_nil
      end
    end
  end
end