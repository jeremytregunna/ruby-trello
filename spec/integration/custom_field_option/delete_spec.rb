require 'spec_helper'

RSpec.describe 'Trello::CustomFieldOption#delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success delete the custom_field_option' do
    VCR.use_cassette('can_success_delete_a_custom_field_option') do
      custom_field_option = Trello::CustomFieldOption.find('5fa7bb27621fcf64876dcc85', custom_field_id: '5fa7589441b04c2cf1fc773a')
      custom_field_option.delete

      custom_field = Trello::CustomField.find('5fa7589441b04c2cf1fc773a')
      custom_field_options = custom_field.custom_field_options

      expect(custom_field_options.map(&:id)).not_to include('5fa7bb27621fcf64876dcc85')
    end
  end
end
