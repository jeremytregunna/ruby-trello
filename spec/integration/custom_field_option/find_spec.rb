require 'spec_helper'

RSpec.describe 'Trello::CustomFieldOption#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('custom_field_option_find_with_id') do
      custom_field_option = Trello::CustomFieldOption.find('5fa7589441b04c2cf1fc773b', custom_field_id: '5fa7589441b04c2cf1fc773a')
      expect(custom_field_option).to be_a(Trello::CustomFieldOption)

      expect(custom_field_option.id).not_to be_nil
      expect(custom_field_option.custom_field_id).not_to be_nil
      expect(custom_field_option.value).not_to be_nil
      expect(custom_field_option.color).not_to be_nil
      expect(custom_field_option.position).not_to be_nil
    end
  end

end
