require 'spec_helper'

module Trello
  describe Notification do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/members/abcdef123456789012345678").and_return user_payload
      member = Member.find("abcdef123456789012345678")
      Client.stub(:get).with("/members/abcdef123456789012345678/notifications", {}).and_return "[" << notification_payload << "]"
      @notification = member.notifications.first
    end

    context "finding" do
      it "can find a specific notification" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}").and_return notification_payload
        Notification.find(notification_details['id']).should == @notification
      end
    end

    context "boards" do
      it "can retrieve the board" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}/board").and_return JSON.generate(boards_details.first)
        @notification.board.id.should == boards_details.first['id']
      end
    end

    context "lists" do
      it "can retrieve the list" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}/list").and_return JSON.generate(lists_details.first)
        @notification.list.id.should == lists_details.first['id']
      end
    end

    context "cards" do
      it "can retrieve the card" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}/card").and_return JSON.generate(cards_details.first)
        @notification.card.id.should == cards_details.first['id']
      end
    end

    context "members" do
      it "can retrieve the member" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}/member").and_return user_payload
        @notification.member.id.should == user_details['id']
      end

      it "can retrieve the member creator" do
        Client.stub(:get).with("/members/#{user_details['id']}").and_return user_payload
        @notification.member_creator.id.should == user_details['id']
      end
    end

    context "organization" do
      it "can retrieve the organization" do
        Client.stub(:get).with("/notifications/#{notification_details['id']}/organization").and_return JSON.generate(orgs_details.first)
        @notification.organization.id.should == orgs_details.first['id']
      end
    end

    context "local" do
      it "gets the read status" do
        @notification.unread?.should == notification_details['unread']
      end

      it "gets the type" do
        @notification.type.should == notification_details['type']
      end

      it "gets the date" do
        @notification.date.should == notification_details['date']
      end

      it "gets the data" do
        @notification.data.should == notification_details['data']
      end

      it "gets the member creator id" do
        @notification.member_creator_id.should == notification_details['idMemberCreator']
      end
    end
  end
end