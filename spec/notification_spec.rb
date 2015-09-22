require 'spec_helper'

module Trello
  describe Notification do
    include Helpers

    let(:notification) { member.notifications.first }
    let(:member) { client.find(:member, "abcdef123456789012345678") }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with("/members/abcdef123456789012345678", {})
        .and_return user_payload

      allow(client)
        .to receive(:get)
        .with("/members/abcdef123456789012345678/notifications", {})
        .and_return("[" << notification_payload << "]")
    end

    context "finding" do
      let(:client) { Trello.client }

      it "can find a specific notification" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}", {})
          .and_return notification_payload

        expect(Notification.find(notification_details['id'])).to eq notification
      end
    end

    context "boards" do
      it "can retrieve the board" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}/board")
          .and_return JSON.generate(boards_details.first)

        expect(notification.board.id).to eq boards_details.first['id']
      end
    end

    context "lists" do
      it "can retrieve the list" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}/list")
          .and_return JSON.generate(lists_details.first)

        expect(notification.list.id).to eq lists_details.first['id']
      end
    end

    context "cards" do
      it "can retrieve the card" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}/card")
          .and_return JSON.generate(cards_details.first)

        expect(notification.card.id).to eq cards_details.first['id']
      end
    end

    context "members" do
      it "can retrieve the member" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}/member")
          .and_return user_payload

        expect(notification.member.id).to eq user_details['id']
      end

      it "can retrieve the member creator" do
        allow(client)
          .to receive(:get)
          .with("/members/#{user_details['id']}", {})
          .and_return user_payload

        expect(notification.member_creator.id).to eq user_details['id']
      end
    end

    context "organization" do
      it "can retrieve the organization" do
        allow(client)
          .to receive(:get)
          .with("/notifications/#{notification_details['id']}/organization")
          .and_return JSON.generate(orgs_details.first)

        expect(notification.organization.id).to eq orgs_details.first['id']
      end
    end

    context "local" do
      it "gets the read status" do
        expect(notification.unread?).to eq notification_details['unread']
      end

      it "gets the type" do
        expect(notification.type).to eq notification_details['type']
      end

      it "gets the date" do
        expect(notification.date).to eq notification_details['date']
      end

      it "gets the data" do
        expect(notification.data).to eq notification_details['data']
      end

      it "gets the member creator id" do
        expect(notification.member_creator_id).to eq notification_details['idMemberCreator']
      end
    end
  end
end
