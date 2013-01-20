require 'spec_helper'

module Trello
  describe Notification do
    include Helpers

    let(:notification) { member.notifications.first }
    let(:member) { client.find(:member, "abcdef123456789012345678") }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/members/abcdef123456789012345678").and_return user_payload
      client.stub(:get).with("/members/abcdef123456789012345678/notifications", {}).and_return "[" << notification_payload << "]"
    end

    context "finding" do
      let(:client) { Trello.client }

      it "can find a specific notification" do
        client.stub(:get).with("/notifications/#{notification_details['id']}").and_return notification_payload
        Notification.find(notification_details['id']).should == notification
      end
    end

    context "boards" do
      it "can retrieve the board" do
        client.stub(:get).with("/notifications/#{notification_details['id']}/board").and_return JSON.generate(boards_details.first)
        notification.board.id.should == boards_details.first['id']
      end
    end

    context "lists" do
      it "can retrieve the list" do
        client.stub(:get).with("/notifications/#{notification_details['id']}/list").and_return JSON.generate(lists_details.first)
        notification.list.id.should == lists_details.first['id']
      end
    end

    context "cards" do
      it "can retrieve the card" do
        client.stub(:get).with("/notifications/#{notification_details['id']}/card").and_return JSON.generate(cards_details.first)
        notification.card.id.should == cards_details.first['id']
      end
    end

    context "members" do
      it "can retrieve the member" do
        client.stub(:get).with("/notifications/#{notification_details['id']}/member").and_return user_payload
        notification.member.id.should == user_details['id']
      end

      it "can retrieve the member creator" do
        client.stub(:get).with("/members/#{user_details['id']}").and_return user_payload
        notification.member_creator.id.should == user_details['id']
      end
    end

    context "organization" do
      it "can retrieve the organization" do
        client.stub(:get).with("/notifications/#{notification_details['id']}/organization").and_return JSON.generate(orgs_details.first)
        notification.organization.id.should == orgs_details.first['id']
      end
    end

    context "local" do
      it "gets the read status" do
        notification.unread?.should == notification_details['unread']
      end

      it "gets the type" do
        notification.type.should == notification_details['type']
      end

      it "gets the date" do
        notification.date.should == notification_details['date']
      end

      it "gets the data" do
        notification.data.should == notification_details['data']
      end

      it "gets the member creator id" do
        notification.member_creator_id.should == notification_details['idMemberCreator']
      end
    end
  end
end
