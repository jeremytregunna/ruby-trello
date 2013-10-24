require 'spec_helper'

module Trello
  describe Association do
    include Helpers
    
    let(:organization) { client.find(:organization, '4ee7e59ae582acdec8000291') }
    let(:client) { Client.new(:consumer_key => 'xxx') }

    before(:each) do
      client.stub(:get).with('/organizations/4ee7e59ae582acdec8000291', {}).
        and_return organization_payload
      client.stub(:get).with('/organizations/4ee7e59ae582acdec8000291/boards/all').
        and_return boards_payload        
    end
    
    it 'should set the proper client for all associated boards of the organization' do
      organization.boards.first.client.consumer_key.should == 'xxx'
    end
    
  end
end
