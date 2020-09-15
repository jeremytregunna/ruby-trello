require 'spec_helper'

RSpec.describe 'Trello::CustomField#custom_field_options' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get custom_field_options' do
    VCR.use_cassette('can_get_custom_field_options_of_custom_field') do
      custom_field = Trello::CustomField.find('5f60f07958388d26dc063c2d')
      custom_field_options = custom_field.custom_field_options

      expect(custom_field_options).to be_a(Array)
      expect(custom_field_options[0]).to be_a(Trello::CustomFieldOption)
    end
  end

end
