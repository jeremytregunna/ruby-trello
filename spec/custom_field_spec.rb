require 'spec_helper'

module Trello
  describe CustomField do
    include Helpers

    let(:custom_field) { client.find('customFields', 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with("/customFields/abcdef123456789123456789", {})
        .and_return custom_fields_payload
    end

    context "finding" do
      let(:client) { Client.new }

      before do
        allow(client)
          .to receive(:find)
      end

      it "delegates to Trello.client#find" do
        expect(client)
          .to receive(:find)
          .with('customFields', 'abcdef123456789123456789', {})

        CustomField.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        expect(CustomField.find('abcdef123456789123456789')).to eq(custom_field)
      end
    end
  end
end
