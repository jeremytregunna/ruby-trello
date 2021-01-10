require 'spec_helper'

RSpec.describe 'Trello::CustomFieldOption.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the custom_field_option' do
    VCR.use_cassette('can_success_create_a_custom_field_option') do
      custom_field_option = Trello::CustomFieldOption.create(
        custom_field_id: '5fa7589441b04c2cf1fc773a',
        value: { 'text' => 'failed' }
      )
      expect(custom_field_option).to be_a(Trello::CustomFieldOption)

      expect(custom_field_option.id).not_to be_nil
      expect(custom_field_option.custom_field_id).to eq('5fa7589441b04c2cf1fc773a')
      expect(custom_field_option.value).to eq({'text' => 'failed'})
      expect(custom_field_option.color).not_to be_nil
      expect(custom_field_option.position).not_to be_nil
    end
  end
end
