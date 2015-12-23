require 'spec_helper'

module Trello
  describe Checklist do
    include Helpers

    let(:checklist) { client.find(:checklist, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with("/checklists/abcdef123456789123456789", {})
        .and_return JSON.generate(checklists_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        expect(client)
          .to receive(:find)
          .with(:checklist, 'abcdef123456789123456789', {})

        Checklist.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        expect(Checklist.find('abcdef123456789123456789')).to eq(checklist)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it 'creates a new record and saves it on Trello', refactor: true do
        payload = {
            name: 'Test Checklist',
            desc: '',
            card_id: cards_details.first['id']
        }

        attributes = checklists_details.first.merge(payload).except("idBoard")
        result = JSON.generate(attributes)
        

        expected_payload = {name: "Test Checklist", idCard: cards_details.first['id']}

        expect(client)
          .to receive(:post)
          .with("/checklists", expected_payload)
          .and_return result

        checklist = Checklist.create(attributes)

        expect(checklist).to be_a Checklist
      end
    end

    context "deleting" do
      let(:client) { Trello.client }

      it "deletes a checklist" do
        expect(client)
          .to receive(:delete)
          .with("/checklists/#{checklist.id}")

        checklist.delete
      end

      it "deletes a checklist item" do
        item_id = checklist.check_items.first.last
        expect(client)
          .to receive(:delete)
          .with("/checklists/#{checklist.id}/checkItems/#{item_id}")

        checklist.delete_checklist_item(item_id)
      end
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"
        expected_resource = "/checklists/abcdef123456789123456789"
        payload = {
            name: expected_new_name,
            pos: checklist.position
        }

        result = JSON.generate(checklists_details.first)
        expect(client)
          .to receive(:put)
          .once.with(expected_resource, payload)
          .and_return result

        checklist.name = expected_new_name
        checklist.save
      end

      it "updating position does a put on the correct resource with the correct value" do
        expected_new_position = 33
        expected_resource = "/checklists/abcdef123456789123456789"
        payload = {
            name: checklist.name,
            pos: expected_new_position
        }

        result = JSON.generate(checklists_details.first)
        expect(client)
          .to receive(:put)
          .once
          .with(expected_resource, payload)
          .and_return result

        checklist.position = expected_new_position
        checklist.save
      end

      it "adds an item" do
        expected_item_name = "item1"
        expected_checked = true
        expected_pos = 9999
        payload = {
            name: expected_item_name,
            checked: expected_checked,
            pos: expected_pos
        }
        result_hash = {
            name: expected_item_name,
            state: expected_checked ? 'complete' : 'incomplete',
            pos: expected_pos
        }
        result = JSON.generate(result_hash)
        expect(client)
          .to receive(:post)
          .once
          .with("/checklists/abcdef123456789123456789/checkItems", payload)
          .and_return result

        checklist.add_item(expected_item_name, expected_checked, expected_pos)
      end
    end

    context "board" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789")
          .and_return JSON.generate(boards_details.first)
      end

      it "has a board" do
        expect(checklist.board).to_not be_nil
      end
    end

    context "list" do
      before do
        allow(client)
          .to receive(:get)
          .with("/lists/abcdef123456789123456789", {})
          .and_return JSON.generate(lists_details.first)
      end

      it 'has a list' do
        expect(checklist.list).to_not be_nil
      end
    end

    context "making a copy" do
      let(:client) { Trello.client }
      let(:copy_options) { { :name => checklist.name, :idCard => checklist.card_id } }
      let(:copied_checklist) { checklist.copy }

      before(:each) do
        allow(client)
          .to receive(:post)
          .with("/checklists", copy_options)
          .and_return JSON.generate(copied_checklists_details.first)

        allow(checklist)
          .to receive(:items)
          .and_return []
      end

      it "creates a new checklist" do
        expect(copied_checklist).to be_an_instance_of Checklist
      end

      it "is not the same Ruby object as the original checklist" do
        expect(copied_checklist).to_not be checklist
      end

      it "has the same name as the original checklist" do
        expect(copied_checklist.name).to eq checklist.name
      end

      it "has the same board as the original checklist" do
        expect(copied_checklist.board_id).to eq checklist.board_id
      end

      it "creates items for the copy based on the original checklist's items" do
        checklist_copy  = Trello::Checklist.new
        allow(checklist_copy)
          .to receive(:add_item)

        allow(Trello::Checklist)
          .to receive(:create)
          .and_return(checklist_copy)

        incomplete_item = double("incomplete", name: "1", complete?: false)
        complete_item   = double("complete", name: "2", complete?: true)
        checklist_items = [incomplete_item, complete_item]
        allow(checklist).to receive(:items).and_return checklist_items

        checklist_items.each do |item|
          expect(checklist_copy)
            .to receive(:add_item)
            .with(item.name, item.complete?)
        end

        checklist.copy
      end
    end
  end
end
