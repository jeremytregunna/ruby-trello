require 'spec_helper'

module Trello
  describe Label do
    include Helpers

    let(:label) { client.find(:label, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with("/labels/abcdef123456789123456789", {})
        .and_return JSON.generate(label_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        expect(client)
          .to receive(:find)
          .with(:label, 'abcdef123456789123456789', {})

        Label.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        expect(Label.find('abcdef123456789123456789')).to eq(label)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it "creates a new record" do
        expect(Label.new(label_details.first)).to be_valid
      end

      it "initializes all fields from response-like formatted hash" do
        details = label_details.first
        label = Label.new(details)
        expect(label.color).to    eq details['color']
        expect(label.name).to     eq details['name']
        expect(label.id).to       eq details['id']
        expect(label.uses).to     eq details['uses']
        expect(label.board_id).to eq details['idBoard']
      end

      it "initializes required fields from options-like formatted hash" do
        details = label_options
        label = Label.new(details)
        expect(label.name).to     eq details[:name]
        expect(label.board_id).to eq details[:board_id]
        expect(label.color).to    eq details[:color]
      end

      it 'must not be valid if not given a name' do
        expect(Label.new('idBoard' => lists_details.first['board_id'])).to_not be_valid
      end

      it 'must not be valid if not given a board id' do
        expect(Label.new('name' => lists_details.first['name'])).to_not be_valid
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        payload = {
          name: 'Test Label',
          board_id: 'abcdef123456789123456789',
        }

        result = JSON.generate(cards_details.first.merge(payload.merge(idBoard: boards_details.first['id'])))

        expected_payload = {name: "Test Label", color: nil, idBoard: "abcdef123456789123456789" }

        expect(client)
          .to receive(:post)
          .with("/labels", expected_payload)
          .and_return result

        label = Label.create(label_details.first.merge(payload.merge(board_id: boards_details.first['id'])))

        expect(label).to be_a Label
      end
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"

        payload = {
          name: expected_new_name,
        }

        expect(client)
          .to receive(:put)
          .once
          .with("/labels/abcdef123456789123456789", payload)

        label.name = expected_new_name
        label.save
      end

      it "updating color does a put on the correct resource with the correct value" do
        expected_new_color = "purple"

        payload = {
          color: expected_new_color,
        }

        expect(client)
          .to receive(:put)
          .once
          .with("/labels/abcdef123456789123456789", payload)

        label.color = expected_new_color
        label.save
      end

      it "can update with any valid color" do
        %w(green yellow orange red purple blue sky lime pink black).each do |color|
          allow(client)
            .to receive(:put)
            .with("/labels/abcdef123456789123456789", {color: color})
            .and_return "not important"

          label.color = color
          label.save
          expect(label.errors).to be_empty
        end
      end

      it "throws an error when trying to update a label with an unknown colour" do
        allow(client)
          .to receive(:put)
          .with("/labels/abcdef123456789123456789", {})
          .and_return "not important"

        label.color = 'mauve'
        label.save

        expect(label.errors.full_messages.to_sentence).to eq("Label color 'mauve' does not exist")
      end
    end

    context "deleting" do
      it "deletes the label" do
        expect(client)
          .to receive(:delete)
          .with("/labels/#{label.id}")

        label.delete
      end
    end

    context "fields" do
      it "gets its id" do
        expect(label.id).to_not be_nil
      end

      it "gets its name" do
        expect(label.name).to_not be_nil
      end

      it "gets its usage" do
        expect(label.uses).to_not be_nil
      end

      it "gets its color" do
        expect(label.color).to_not be_nil
      end
    end

    context "boards" do
      it "has a board" do
        expect(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789", {})
          .and_return JSON.generate(boards_details.first)

        expect(label.board).to_not be_nil
      end
    end

    describe "#update_fields" do
      it "does not set any fields when the fields argument is empty" do
        expected = {
          'id' => 'id',
          'name' => 'name',
          'color' => 'color',
          'idBoard' => 'board_id',
          'uses' => 'uses'
        }

        label = Label.new(expected)

        label.update_fields({})

        expected.each do |key, value|
          expect(label.send(value)).to eq expected[key]
        end
      end
    end
  end
end
