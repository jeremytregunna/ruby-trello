require 'spec_helper'

module Trello
  describe Action do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_request(:get, "https://api.trello.com/1/actions/abcdef123456789123456789?").
        with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
        to_return(:status => 200, :headers => {}, :body => JSON.generate(actions_details.first))

      @action = Action.find('abcdef123456789123456789')
    end

    context "fields" do
      before(:all) do
        @detail = actions_details.first
      end

      it "gets its id" do
        @action.id.should == @detail['id']
      end

      it "gets its type" do
        @action.type.should == @detail['type']
      end

      it "has the same data" do
        @action.data.should == @detail['data']
      end
    end
  end
end