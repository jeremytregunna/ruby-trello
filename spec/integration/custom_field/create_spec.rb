require 'spec_helper'

RSpec.describe 'Trello::CustomField.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the custom_field' do
    VCR.use_cassette('can_success_create_a_custom_field') do
      custom_field = Trello::CustomField.create(
        name: 'Started',
        model_id: '5e93ba98614ac22d22f085c4',
        model_type: 'board',
        enable_display_on_card: true,
        position: 'bottom',
        type: 'checkbox'
      )
      expect(custom_field).to be_a(Trello::CustomField)

      expect(custom_field.id).not_to be_nil
      expect(custom_field.name).to eq('Started')
      expect(custom_field.model_id).to eq('5e93ba98614ac22d22f085c4')
      expect(custom_field.model_type).to eq('board')
      expect(custom_field.enable_display_on_card).to eq(true)
      expect(custom_field.position).not_to be_nil
      expect(custom_field.type).to eq('checkbox')
    end
  end
end
