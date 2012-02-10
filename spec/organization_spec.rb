
require 'spec_helper'

module Trello
  describe Organization do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/organizations/4ee7e59ae582acdec8000291").
        and_return organization_payload

      @organization = Organization.find('4ee7e59ae582acdec8000291')
    end

    context "actions" do
      it "retrieves actions" do
        Client.stub(:get).with("/organizations/4ee7e59ae582acdec8000291/actions", { :filter => :all }).and_return actions_payload
        @organization.actions.count.should be > 0
      end

    end

  end

end

