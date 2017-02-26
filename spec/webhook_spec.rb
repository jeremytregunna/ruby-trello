require 'spec_helper'

module Trello
  describe Webhook do
    include Helpers

    let(:webhook) { client.find(:webhook, "1234") }
    let(:client) { Client.new }

    before(:each) do
      allow(client)
        .to receive(:get)
        .with("/webhooks/1234", {})
        .and_return webhook_payload
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to Trello.client#find" do
        expect(client)
          .to receive(:find)
          .with(:webhook, '1234', {})

        Webhook.find('1234')
      end

      it "is equivalent to client#find" do
        expect(Webhook.find('1234')).to eq(webhook)
      end
    end

    context "creating" do
      let(:client) { Trello.client }

      it "creates a new webhook" do
        webhook = Webhook.new(webhooks_details.first)
        expect(webhook).to be_valid
      end

      it "initializes all fields from response-like formatted hash" do
        webhook_details = webhooks_details.first
        webhook = Webhook.new(webhook_details)
        expect(webhook.id).to           eq webhook_details['id']
        expect(webhook.description).to  eq webhook_details['description']
        expect(webhook.id_model).to     eq webhook_details['idModel']
        expect(webhook.callback_url).to eq webhook_details['callbackURL']
        expect(webhook.active).to       eq webhook_details['active']
      end

      it "initializes required fields from options-like formatted hash" do
        webhook_details = webhooks_details[1]
        webhook = Webhook.new(webhook_details)
        expect(webhook.description).to  eq webhook_details[:description]
        expect(webhook.id_model).to     eq webhook_details[:id_model]
        expect(webhook.callback_url).to eq webhook_details[:callback_url]
      end

      it 'creates a new webhook and saves it on Trello', refactor: true do
        payload = { name: 'Test Card', desc: nil }

        webhook = webhooks_details.first
        result = JSON.generate(webhook)

        expected_payload = {description: webhook[:description], idModel: webhook[:idModel], callbackURL: webhook[:callbackURL]}

        expect(client)
          .to receive(:post)
          .with("/webhooks", expected_payload)
          .and_return result

        webhook = Webhook.create(webhooks_details.first)

        expect(webhook.class).to be Webhook
      end
    end

    context "updating" do
      it "updating description does a put on the correct resource with the correct value" do
        expected_new_description = "xxx"

        expected_payload = {description: expected_new_description, idModel: webhook.id_model, callbackURL: webhook.callback_url, active: webhook.active}

        expect(client)
          .to receive(:put)
          .once
          .with("/webhooks/#{webhook.id}", expected_payload)

        webhook.description = expected_new_description
        webhook.save
      end
    end

    context "deleting" do
      it "deletes the webhook" do
        expect(client)
          .to receive(:delete)
          .with("/webhooks/#{webhook.id}")

        webhook.delete
      end
    end

    context "activated?" do
      it "returns the active attribute" do
        expect(webhook).to be_activated
      end
    end

    describe "#update_fields" do
      it "does not set any fields when the fields argument is empty" do
        expected = {
          'id' => 'id',
          'description' => 'description',
          'idModel' => 'id_model',
          'callbackURL' => 'callback_url',
          'active' => 'active'
        }

        webhook = Webhook.new(expected)

        webhook.update_fields({})

        expected.each do |key, value|
          expect(webhook.send(value)).to eq expected[key]
        end
      end
    end
  end
end
