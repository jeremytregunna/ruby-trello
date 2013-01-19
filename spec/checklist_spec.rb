require 'spec_helper'

module Trello
  describe Checklist do
    include Helpers

    let(:checklist) { client.find(:checklists, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/checklists/abcdef123456789123456789").
        and_return JSON.generate(checklists_details.first)
    end

    context "self.find" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:checklists, 'abcdef123456789123456789')
        Checklist.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        Checklist.find('abcdef123456789123456789').should eq(checklist)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it 'creates a new record and saves it on Trello', :refactor => true do
        payload = {
          :name    => 'Test Checklist',
          :desc    => '',
        }

        result = JSON.generate(checklists_details.first.merge(payload.merge(:idBoard => boards_details.first['id'])))

        expected_payload = {:name => "Test Checklist", :idBoard => "abcdef123456789123456789"}

        client.should_receive(:post).with("/checklists", expected_payload).and_return result

        checklist = Checklist.create(checklists_details.first.merge(payload.merge(:board_id => boards_details.first['id'])))

        checklist.class.should be Checklist
      end
    end

    context "updating" do
      it "updating name does a put on the correct resource with the correct value" do
        expected_new_name = "xxx"
        expected_resource = "/checklists/abcdef123456789123456789"
        payload = {
          :name      => expected_new_name
        }

        result = JSON.generate(checklists_details.first)
        client.should_receive(:put).once.with("/checklists/abcdef123456789123456789", payload).and_return result

        checklist.name = expected_new_name
        checklist.save
      end
    end

  end
end
