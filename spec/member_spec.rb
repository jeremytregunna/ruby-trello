# Specs covering the members namespace in the Trello API

require 'spec_helper'

module Trello
  describe Member do
    include Helpers

    let(:member) { client.find(:member, 'abcdef123456789012345678') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/members/abcdef123456789012345678", {}).and_return user_payload
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:member, 'abcdef123456789012345678', {})
        Member.find('abcdef123456789012345678')
      end

      it "is equivalent to client#find" do
        Member.find('abcdef123456789012345678').should eq(member)
      end
    end

    context "actions" do
      it "retrieves a list of actions", :refactor => true do
        client.stub(:get).with("/members/abcdef123456789012345678/actions", { :filter => :all }).and_return actions_payload
        member.actions.count.should be > 0
      end
    end

    context "boards" do
      it "has a list of boards" do
        client.stub(:get).with("/members/abcdef123456789012345678/boards", { :filter => :all }).and_return boards_payload
        boards = member.boards
        boards.count.should be > 0
      end
    end

    context "cards" do
      it "has a list of cards" do
        client.stub(:get).with("/members/abcdef123456789012345678/cards", { :filter => :open }).and_return cards_payload
        cards = member.cards
        cards.count.should be > 0
      end
    end

    context "organizations" do
      it "has a list of organizations" do
        client.stub(:get).with("/members/abcdef123456789012345678/organizations", { :filter => :all }).and_return orgs_payload
        orgs = member.organizations
        orgs.count.should be > 0
      end
    end

    context "notifications" do
      it "has a list of notifications" do
        client.stub(:get).with("/members/abcdef123456789012345678/notifications", {}).and_return "[" << notification_payload << "]"
        member.notifications.count.should be 1
      end
    end

    context "personal" do
      it "gets the members bio" do
        member.bio.should == user_details['bio']
      end

      it "gets the full name" do
        member.full_name.should == user_details['fullName']
      end

      it "gets the avatar id" do
        member.avatar_id.should == user_details['avatarHash']
      end

      it "returns a valid url for the avatar" do
        member.avatar_url(:size => :large).should == "https://trello-avatars.s3.amazonaws.com/abcdef1234567890abcdef1234567890/170.png"
        member.avatar_url(:size => :small).should == "https://trello-avatars.s3.amazonaws.com/abcdef1234567890abcdef1234567890/30.png"
      end

      it "gets the url" do
        member.url.should == user_details['url']
      end

      it "gets the username" do
        member.username.should == user_details['username']
      end

      it "gets the email" do
        member.email.should == user_details['email']
      end

      it "gets the initials" do
        member.initials.should == user_details['initials']
      end
    end

    context "modification" do
      it "lets us know a field has changed without committing it" do
        member.changed?.should be_false
        member.bio = "New and amazing"
        member.changed?.should be_true
      end

      it "doesn't understand the #id= method" do
        lambda { member.id = "42" }.should raise_error NoMethodError
      end
    end
  end
end
