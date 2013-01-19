
require 'spec_helper'

module Trello
  describe Organization do
    include Helpers

    let(:organization) { client.find(:organizations, "4ee7e59ae582acdec8000291") }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/organizations/4ee7e59ae582acdec8000291").
        and_return organization_payload
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:organizations, '4ee7e59ae582acdec8000291')
        Organization.find('4ee7e59ae582acdec8000291')
      end

      it "is equivalent to client#find" do
        Organization.find('4ee7e59ae582acdec8000291').should eq(organization)
      end
    end

    context "actions" do
      it "retrieves actions" do
        client.stub(:get).with("/organizations/4ee7e59ae582acdec8000291/actions", { :filter => :all }).and_return actions_payload
        organization.actions.count.should be > 0
      end
    end
  end
end

