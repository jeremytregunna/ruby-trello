require 'spec_helper'

module Trello
  describe Webhook do
    include Helpers

    let(:webhook) { client.find(:webhook, "1234") }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with("/webhooks/1234", {}).and_return webhook_payload
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        client.should_receive(:find).with(:webhook, '1234', {})
        Webhook.find('1234')
      end

      it "is equivalent to client#find" do
        Webhook.find('1234').should eq(webhook)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it "creates a new webhook" do
        webhook = Webhook.new(webhooks_details.first)
        webhook.should be_valid
      end

      it 'creates a new webhook and saves it on Trello', :refactor => true do
        payload = {
          :name    => 'Test Card',
          :desc    => nil,
        }

        webhook = webhooks_details.first
        result = JSON.generate(webhook)

        expected_payload = {:description => webhook[:description], :idModel => webhook[:idModel], :callbackURL => webhook[:callbackURL]}

        client.should_receive(:post).with("/webhooks", expected_payload).and_return result

        webhook = Webhook.create(webhooks_details.first)

        webhook.class.should be Webhook
      end
    end

    context "updating" do
      it "updating description does a put on the correct resource with the correct value" do
        expected_new_description = "xxx"

        expected_payload = {:description => expected_new_description, :idModel => webhook.idModel, :callbackURL => webhook.callbackURL, :active => webhook.active}

        client.should_receive(:put).once.with("/webhooks/#{webhook.id}", expected_payload)

        webhook.description = expected_new_description
        webhook.save
      end
    end

    context "deleting" do
      it "deletes the webhook" do
        client.should_receive(:delete).with("/webhooks/#{webhook.id}")
        webhook.delete
      end
    end
  end
end
