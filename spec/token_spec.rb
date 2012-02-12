require 'spec_helper'

module Trello
  describe Token do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/tokens/1234").and_return token_payload
      @token = Token.find("1234")
    end

    context "attributes" do
      it "has an id" do
        @token.id.should == "4f2c10c7b3eb95a45b294cd5"
      end

      it "gets its created_at date" do
        @token.created_at.should == Time.iso8601("2012-02-03T16:52:23.661Z")
      end

      it "has a permission grant" do
        @token.permissions.count.should be 3
      end
    end

    context "members" do
      it "retrieves the member who authorized the token" do
        Client.stub(:get).with("/members/abcdef123456789123456789").and_return user_payload
        @token.member.should == Member.find("abcdef123456789123456789")
      end
    end
  end
end