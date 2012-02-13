# Specs covering the members namespace in the Trello API

require 'spec_helper'

module Trello
  describe Member do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/members/abcdef123456789012345678").and_return user_payload

      @member = Member.find('abcdef123456789012345678')
    end

    context "actions" do
      it "retrieves a list of actions", :refactor => true do
        Client.stub(:get).with("/members/abcdef123456789012345678/actions", { :filter => :all }).and_return actions_payload
        @member.actions.count.should be > 0
      end
    end

    context "boards" do
      it "has a list of boards" do
        Client.stub(:get).with("/members/abcdef123456789012345678/boards", { :filter => :all }).and_return boards_payload
        boards = @member.boards
        boards.count.should be > 0
      end
    end

    context "cards" do
      it "has a list of cards" do
        Client.stub(:get).with("/members/abcdef123456789012345678/cards", { :filter => :open }).and_return cards_payload
        cards = @member.cards
        cards.count.should be > 0
      end
    end

    context "organizations" do
      it "has a list of organizations" do
        Client.stub(:get).with("/members/abcdef123456789012345678/organizations", { :filter => :all }).and_return orgs_payload
        orgs = @member.organizations
        orgs.count.should be > 0
      end
    end

    context "notifications" do
      it "has a list of notifications" do
        Client.stub(:get).with("/members/abcdef123456789012345678/notifications", {}).and_return "[" << notification_payload << "]"
        @member.notifications.count.should be 1
      end
    end

    context "personal" do
      it "gets the members bio" do
        @member.bio.should == user_details['bio']
      end

      it "gets the full name" do
        @member.full_name.should == user_details['fullName']
      end

      it "gets the avatar id" do
        @member.avatar_id.should == user_details['avatarHash']
      end

      it "returns a valid url for the avatar" do
        @member.avatar_url(:size => :large).should == "https://trello-avatars.s3.amazonaws.com/abcdef1234567890abcdef1234567890/170.png"
        @member.avatar_url(:size => :small).should == "https://trello-avatars.s3.amazonaws.com/abcdef1234567890abcdef1234567890/30.png"
      end

      it "gets the url" do
        @member.url.should == user_details['url']
      end

      it "gets the username" do
        @member.username.should == user_details['username']
      end
    end

    context "modification" do
      it "lets us know a field has changed without committing it" do
        @member.changed?.should be_false
        @member.bio = "New and amazing"
        @member.changed?.should be_true
      end

      it "doesn't understand the #id= method" do
        lambda { @member.id = "42" }.should raise_error NoMethodError
      end
    end
  end
end
