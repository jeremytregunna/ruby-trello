require 'spec_helper'

module Trello
  describe Checklist do
    include Helpers

    let(:checklist) { Checklist.find('abcdef123456789123456789') }

    before(:each) do
      Client.stub(:get).with("/checklists/abcdef123456789123456789").
        and_return JSON.generate(checklists_details.first)
    end

    context "creating" do
      it 'creates a new record and saves it on Trello', :refactor => true do
        payload = {
          :name    => 'Test Checklist',
          :desc    => '',
        }

        result = JSON.generate(checklists_details.first.merge(payload.merge(:idBoard => boards_details.first['id'])))

        expected_payload = {:name => "Test Checklist", :idBoard => "abcdef123456789123456789"}

        Client.should_receive(:post).with("/checklists", expected_payload).and_return result

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
        Client.should_receive(:put).once.with("/checklists/abcdef123456789123456789", payload).and_return result

        checklist.name = expected_new_name
        checklist.save
      end
    end

  end
end
