# Specs covering the members namespace in the Trello API

require 'spec_helper'

module Trello
  describe Member do
    before(:all) do
      Client.public_key = TEST_PUBLIC_KEY
      Client.secret     = TEST_SECRET
      @member = Member.find('jer')
    end

    context "actions" do
      # This spec needs a better name
      it "retrieves a list of actions"
    end

    context "boards" do
    end

    context "cards" do
    end

    context "organizations" do
    end

    context "personal" do
      it "gets the members bio" do
        @member.bio.should_not be_nil
      end

      it "gets the full name" do
        @member.full_name.should_not be_nil
      end

      it "gets the gravatar id" do
        @member.gravatar_id.should_not be_nil
      end

      it "gets the url" do
        @member.url.should_not be_nil
      end

      it "gets the username" do
        @member.username.should_not be_nil
      end
    end
  end
end