require 'spec_helper'

RSpec.describe 'Trell::CustomField.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a custom_field' do
    VCR.use_cassette('can_success_update_bong_a_custom_field') do
      custom_field = Trello::CustomField.find('5f60edcbe0610f8811951cae')

      expect(custom_field.name).to eq('Started')
      expect(custom_field.enable_display_on_card).to eq(true)

      custom_field.name = 'Started - Change'
      custom_field.enable_display_on_card = false

      custom_field.update!

      expect(custom_field.name).to eq('Started - Change')
      expect(custom_field.enable_display_on_card).to eq(false)
    end
  end

end
