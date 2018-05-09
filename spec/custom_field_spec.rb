require 'spec_helper'

module Trello
  describe CustomField do
    include Helpers

    let(:custom_field) { client.find('customFields', 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with('customFields/abcdef123456789123456789', {})
        .and_return custom_fields_payload
    end

    context 'creating' do
      let(:client) { Trello.client }

      it 'creates a new CustomField record' do
        custom_fields_details.each do |details|
          custom_field = CustomField.new(details)
          expect(custom_field).to be_valid
        end
      end

      it 'properly initializes all fields from response-like formatted hash' do
        custom_field_details = custom_fields_details.first
        custom_field = CustomField.new(custom_field_details)
        expect(custom_field.id).to          eq(custom_field_details['id'])
        expect(custom_field.name).to        eq(custom_field_details['name'])
        expect(custom_field.type).to        eq(custom_field_details['type'])
        expect(custom_field.pos).to         eq(custom_field_details['pos'])
        expect(custom_field.model_id).to    eq(custom_field_details['idModel'])
        expect(custom_field.model_type).to  eq(custom_field_details['modelType'])
      end

      it 'properly initializes all fields from options-like formatted hash' do
        custom_field_details = custom_fields_details[1]
        custom_field = CustomField.new(details)
        expect(custom_field.id).to          eq(custom_field_details[:id])
        expect(custom_field.name).to        eq(custom_field_details[:name])
        expect(custom_field.type).to        eq(custom_field_details[:type])
        expect(custom_field.pos).to         eq(custom_field_details[:pos])
        expect(custom_field.model_id).to    eq(custom_field_details[:model_id])
        expect(custom_field.model_type).to  eq(custom_field_details[:model_type])
      end

      it 'validates presence of id, name, model id, model type, type, and position' do
        custom_field = CustomField.new
        expect(custom_field).to_not be_valid
        expect(custom_field.errors.count).to eq(6)
        expect(custom_field.errors).to include(:name)
        expect(custom_field.errors).to include(:id)
        expect(custom_field.errors).to include(:model_id)
        expect(custom_field.errors).to include(:model_type)
        expect(custom_field.errors).to include(:pos)
        expect(custom_field.errors).to include(:type)
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        test_payload = {
          name: 'Test Custom Field'
        }

        result = JSON.generate(custom_fields_details.first.merge(test_payload))
        expected_payload = {name: 'Test Custom Field', type: 'checkbox', idModel: 'abc123',
                            modelType: 'board', pos: 123, fieldGroup: nil}

        expect(client)
          .to receive(:post)
          .with('/customFields', expected_payload)
          .and_return result

        custom_field = CustomField.create(custom_fields_details[1].merge(test_payload))
        expect(custom_field).to be_a CustomField
      end
    end

    context 'finding' do
      let(:client) { Trello.client }

      before do
        allow(client)
          .to receive(:find)
      end

      it 'delegates to Trello.client#find' do
        expect(client)
          .to receive(:find)
          .with('customFields', 'abcdef123456789123456789', {})

        CustomField.find('abcdef123456789123456789')
      end

      it 'is equivalent to client#find' do
        expect(CustomField.find('abcdef123456789123456789')).to eq(custom_field)
      end
    end
  end
end
