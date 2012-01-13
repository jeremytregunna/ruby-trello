# Specs covering the members namespace in the Trello API

require 'spec_helper'

module Trello
  describe Member do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      Client.stub(:get).with("/members/me").and_return user_payload

      @member = Member.find('me')
    end

    context "actions" do
      it "retrieves a list of actions", :refactor => true do
        Client.stub(:get).with("/members/me/actions").and_return actions_payload
        @member.actions.count.should be > 0
      end
    end

    context "boards" do
      it "has a list of boards" do
        Client.stub(:get).with("/members/me/boards", { :filter => :all }).and_return boards_payload
        boards = @member.boards
        boards.count.should be > 0
      end
    end

    context "cards" do
      it "has a list of cards" do
        Client.stub(:get).with("/members/me/cards", { :filter => :open }).and_return cards_payload
        cards = @member.cards
        cards.count.should be > 0
      end
    end

    context "organizations" do
      it "has a list of organizations" do
        Client.stub(:get).with("/members/me/organizations", { :filter => :all }).and_return orgs_payload
        orgs = @member.organizations
        orgs.count.should be > 0
      end
    end

    context "personal" do
      it "gets the members bio" do
        @member.bio.should == user_details['bio']
      end

      it "gets the full name" do
        @member.full_name.should == user_details['fullName']
      end

      it "gets the gravatar id" do
        @member.gravatar_id.should == user_details['gravatar']
      end

      it "gets the url" do
        @member.url.should == user_details['url']
      end

      it "gets the username" do
        @member.username.should == user_details['username']
      end
    end
  end
end
