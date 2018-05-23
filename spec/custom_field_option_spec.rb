require 'spec_helper'

module Trello
  describe CustomFieldOption do
    include Helpers

    let(:option) { CustomFieldOption.new(custom_field_option_details) }

    it 'validates presence of value and id' do
      invalid_option = CustomFieldOption.new

      expect(invalid_option).to be_invalid
      expect(invalid_option.errors).to include(:value)
      expect(invalid_option.errors).to include(:id)
    end

    describe 'retrieve option fields' do
      it 'gets its id' do
        expect(option.id).to eq custom_field_option_details['_id']
      end

      it 'gets its color' do
        expect(option.color).to eq custom_field_option_details['color']
      end

      it 'knows its value' do
        expect(option.value).to eq custom_field_option_details['value']
      end

      it 'gets its pos' do
        expect(option.pos).to eq custom_field_option_details['pos']
      end
    end

    describe 'update fields' do
      it 'allows fields to be updated' do
        updated = {
          color: "purple",
          value: { "text" => "Medium Priority" }
        }

        option.update_fields(updated)

        expect(option.color).to eq "purple"
        expect(option.value).to eq({"text" => "Medium Priority"})
      end
    end
  end
end
