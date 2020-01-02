require 'spec_helper'

module Trello
  describe CustomFieldItem do
    include Helpers

    let(:text_field_details) {
      {
        'id'   => 'abcdefgh12345678',
        'value' => {"text" => "Low Priority"},
        'idValue' => nil,
        'idModel' => 'abc123',
        'idCustomField' => 'abcd1234',
        'modelType' => 'card'
      }
    }

    let(:list_item_details) {
      {
        'id'   => 'abcdefgh12345678',
        'value' => nil,
        'idValue' => 'abcde12345',
        'idModel' => 'abc123',
        'idCustomField' => 'abcd1234',
        'modelType' => 'card'
      }
    }

    let(:client) { Client.new }
    let(:text_item) { CustomFieldItem.new(text_field_details) }
    let(:list_item) { CustomFieldItem.new(list_item_details) }

    it 'validates presence of id, model ID and custom field ID' do
      invalid_item = CustomFieldItem.new

      expect(invalid_item).to be_invalid
      expect(invalid_item.errors).to include(:id)
      expect(invalid_item.errors).to include(:model_id)
      expect(invalid_item.errors).to include(:custom_field_id)
    end

    describe 'retrieve item fields' do
      it 'gets its id' do
        expect(text_item.id).to eq text_field_details['id']
      end

      it 'gets its value' do
        expect(text_item.value).to eq text_field_details['value']
      end

      it 'gets its model type' do
        expect(text_item.model_type).to eq text_field_details['modelType']
      end

      it 'gets its model ID' do
        expect(text_item.model_id).to eq text_field_details['idModel']
      end

      it 'gets its custom field ID' do
        expect(text_item.custom_field_id).to eq text_field_details['idCustomField']
      end

      it 'has a value ID for list option' do
        expect(list_item.option_id).to eq list_item_details['idValue']
      end
    end

    describe 'list option' do
      let(:client) { Trello.client }

      before do
        allow(client)
          .to receive(:get)
          .with("/customFields/#{list_item.custom_field_id}/options/#{list_item.option_id}")
          .and_return JSON.generate(custom_field_option_details)
      end

      it 'gets the value' do
        expect(list_item.option_value).to_not be_nil
      end
    end

    describe 'custom field' do
      let(:client) { Trello.client }

      before do
        allow(client)
          .to receive(:get)
          .with("/customFields/abcd1234", {})
          .and_return JSON.generate(custom_fields_details.first)
      end

      it 'has a custom field' do
        expect(text_item.custom_field).to be_a CustomField
        expect(text_item.custom_field.name).to eq('Priority')
      end

      it 'returns the custom field type' do
        expect(text_item.type).to eq 'checkbox'
      end
    end

    describe 'card' do
      let(:client) { Trello.client }

      before do
        allow(client)
          .to receive(:get)
          .with("/cards/abc123", {})
          .and_return JSON.generate(cards_details.first)
      end

      it 'has a card' do
        expect(text_item.card).to be_a Card
      end
    end

    describe '#update_fields' do

      context 'when the fields argument is empty' do
        let(:fields) { {} }

        it 'custom field item does not set any fields' do
          text_item.update_fields(fields)

          expect(text_item.id).to eq text_field_details['id']
          expect(text_item.option_id).to eq text_field_details['idValue']
          expect(text_item.model_id).to eq text_field_details['idModel']
          expect(text_item.custom_field_id).to eq text_field_details['idCustomField']
          expect(text_item.model_type).to eq text_field_details['modelType']
          expect(text_item.value).to eq text_field_details['value']
        end
      end

      context 'when the fields argument has at least one field' do

        context 'and the field does changed' do
          let(:fields) { { value: { number: '42' } } }

          it 'custom field item does set the changed fields' do
            text_item.update_fields(fields)

            expect(text_item.value).to eq( { number: '42' } )
          end

          it 'card has been mark as changed' do
            text_item.update_fields(fields)

            expect(text_item.changed?).to be_truthy
          end
        end

        context "and the field doesn't changed" do
          let(:fields) { { value: text_field_details['value'] } }

          it "custom field item attributes doesn't changed" do
            text_item.update_fields(fields)

            expect(text_item.value).to eq(text_field_details['value'])
          end

          it "custom field item hasn't been mark as changed", pending: true do
            text_item.update_fields(fields)

            expect(text_item.changed?).to be_falsy
          end
        end

        context "and the field isn't a correct attributes of the card" do
          let(:fields) { { abc: 'abc' } }

          it "custom field item attributes doesn't changed" do
            text_item.update_fields(fields)

            expect(text_item.id).to eq text_field_details['id']
            expect(text_item.option_id).to eq text_field_details['idValue']
            expect(text_item.model_id).to eq text_field_details['idModel']
            expect(text_item.custom_field_id).to eq text_field_details['idCustomField']
            expect(text_item.model_type).to eq text_field_details['modelType']
            expect(text_item.value).to eq text_field_details['value']
          end

          it "custom field item hasn't been mark as changed" do
            text_item.update_fields(fields)

            expect(text_item.changed?).to be_falsy
          end
        end
      end
    end
  end
end
