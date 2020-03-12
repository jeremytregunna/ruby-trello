require 'spec_helper'

RSpec.describe 'CustomFieldItem API' do

  before do
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY'] || 'developerpublickey'
      config.member_token = ENV['TRELLO_MEMBER_TOKEN'] || 'membertoken'
    end
  end

  describe '#save' do
    context 'when id does not exists' do
      let(:custom_field_item) {
        Trello::CustomFieldItem.new(
          model_id: '5e679be5d53dfa748f41d775',
          custom_field_id: '5e68e8e87c16bf75894df21a',
        )
      }

      it 'update the custom field' do
        VCR.use_cassette('custom_field_item_save_1') do
          custom_field_item.value = { text: 'cool' }
          custom_field_item.save

          expect(custom_field_item.id).not_to be_nil
        end
      end
    end

    context 'when id exists' do
      let(:custom_field_item) {
        card = Trello::Card.find('5e679be5d53dfa748f41d775')
        card.custom_field_items.find { |item| item.id == '5e68e8f02f77a28502efd036' }
      }

      it 'update the custom field' do
        VCR.use_cassette('custom_field_item_save_2') do
          custom_field_item.value = { text: 'nice' }

          expect { custom_field_item.save }.not_to raise_error
        end
      end
    end
  end

end
