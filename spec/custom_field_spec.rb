require 'spec_helper'

module Trello
  describe CustomField do
    include Helpers

    let(:custom_field) { client.find('customFields', 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with('/customFields/abcdef123456789123456789', {})
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
        expect(custom_field.position).to    eq(custom_field_details['pos'])
        expect(custom_field.model_id).to    eq(custom_field_details['idModel'])
        expect(custom_field.model_type).to  eq(custom_field_details['modelType'])
      end

      it 'properly initializes all fields from options-like formatted hash' do
        custom_field_details = custom_fields_details[1]
        custom_field = CustomField.new(custom_field_details)
        expect(custom_field.id).to          eq(custom_field_details[:id])
        expect(custom_field.name).to        eq(custom_field_details[:name])
        expect(custom_field.type).to        eq(custom_field_details[:type])
        expect(custom_field.position).to    eq(custom_field_details[:pos])
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
        expect(custom_field.errors).to include(:position)
        expect(custom_field.errors).to include(:type)
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        test_payload = {
          name: 'Test Custom Field',
          type: 'checkbox',
          model_id: 'abc123',
          model_type: 'board',
          position: 123,
          filed_group: nil
        }

        result = JSON.generate(test_payload)

        expected_payload = {
          'name' => 'Test Custom Field',
          'pos' => 123,
          'idModel' => 'abc123',
          'modelType' => 'board',
          'type' => 'checkbox'
        }

        expect(client)
          .to receive(:post)
          .with('/customFields', expected_payload)
          .and_return result

        custom_field = CustomField.create(test_payload)
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

    context 'updating' do
      it 'correctly updates custom field name' do
        expected_new_name = 'Test Name'

        payload = { 'name' => expected_new_name }

        expect(client)
          .to receive(:put).once
          .with('/customFields/abcdef123456789123456789', payload)
          .and_return(JSON.generate(payload))

        custom_field.name = expected_new_name
        custom_field.save
      end
    end

    context 'fields' do
      it 'gets its id' do
        expect(custom_field.id).to_not be_nil
      end

      it 'gets its name' do
        expect(custom_field.name).to_not be_nil
      end

      it 'gets the model id' do
        expect(custom_field.model_id).to_not be_nil
      end

      it 'gets the model type' do
        expect(custom_field.model_type).to_not be_nil
      end

      it 'gets its type' do
        expect(custom_field.type).to_not be_nil
      end

      it 'gets its position' do
        expect(custom_field.position).to_not be_nil
      end
    end

    context 'boards' do
      before do
        allow(client)
          .to receive(:get)
          .with('/boards/abc123', {})
          .and_return JSON.generate(boards_details.first)
      end

      it 'has a board' do
        expect(custom_field.board).to_not be_nil
      end
    end

    context 'options' do
      it 'creates a new option' do
        payload = { :value => { "text" => "High Priority" } }

        expect(client)
          .to receive(:post)
          .with('/customFields/abcdef123456789123456789/options', payload)

        custom_field.create_new_option({"text" => "High Priority"})
      end

      it 'deletes option' do
        expect(client)
          .to receive(:delete)
          .with('/customFields/abcdef123456789123456789/options/abc123')

        custom_field.delete_option('abc123')
      end
    end

    context 'deleting' do
      it 'deletes the custom field' do
        expect(client)
          .to receive(:delete)
          .with("/customFields/#{custom_field.id}")

        custom_field.delete
      end
    end

    describe '#update_fields' do
      let(:custom_field_detail) { custom_fields_details.first }
      let(:custom_field) { CustomField.new(custom_field_detail) }

      context 'when the fields argument is empty' do
        let(:fields) { {} }

        it 'custom field does not set any fields' do
          custom_field.update_fields(fields)

          expect(custom_field.id).to eq custom_field_detail['id']
          expect(custom_field.model_id).to eq custom_field_detail['idModel']
          expect(custom_field.model_type).to eq custom_field_detail['modelType']
          expect(custom_field.name).to eq custom_field_detail['name']
          expect(custom_field.position).to eq custom_field_detail['pos']
          expect(custom_field.type).to eq custom_field_detail['type']
        end
      end

      context 'when the fields argument has at least one field' do
        context 'and the field does changed' do
          let(:fields) { { name: 'Awesome Name' } }

          it 'custom field does set the changed fields' do
            custom_field.update_fields(fields)

            expect(custom_field.name).to eq('Awesome Name')
          end

          it 'custom field has been mark as changed' do
            custom_field.update_fields(fields)

            expect(custom_field.changed?).to be_truthy
          end
        end

        context "and the field doesn't changed" do
          let(:fields) { { name: custom_field_detail['name'] } }

          it "custom field attributes doesn't changed" do
            custom_field.update_fields(fields)

            expect(custom_field.name).to eq(custom_field_detail['name'])
          end

          it "custom field hasn't been mark as changed" do
            custom_field.update_fields(fields)

            expect(custom_field.changed?).to be_falsy
          end
        end

        context "and the field isn't a correct attributes of the card" do
          let(:fields) { { abc: 'abc' } }

          it "custom field attributes doesn't changed" do
            custom_field.update_fields(fields)

            expect(custom_field.id).to eq custom_field_detail['id']
            expect(custom_field.model_id).to eq custom_field_detail['idModel']
            expect(custom_field.model_type).to eq custom_field_detail['modelType']
            expect(custom_field.name).to eq custom_field_detail['name']
            expect(custom_field.position).to eq custom_field_detail['pos']
            expect(custom_field.type).to eq custom_field_detail['type']
          end

          it "custom field hasn't been mark as changed" do
            custom_field.update_fields(fields)

            expect(custom_field.changed?).to be_falsy
          end
        end
      end
    end

  end
end
