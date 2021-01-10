require 'spec_helper'

RSpec.describe 'Trello::CustomField#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('custom_field_find_with_id_and_get_all_fields') do
      custom_field = Trello::CustomField.find('5f60e443555b8432d959ae94')
      expect(custom_field).to be_a(Trello::CustomField)

      expect(custom_field.id).not_to be_nil
      expect(custom_field.name).not_to be_nil
      expect(custom_field.model_id).not_to be_nil
      expect(custom_field.model_type).not_to be_nil
      expect(custom_field.field_group).not_to be_nil
      expect(custom_field.enable_display_on_card).not_to be_nil
      expect(custom_field.position).not_to be_nil
      expect(custom_field.type).not_to be_nil
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('custom_field_find_with_id_and_get_specific_fields') do
      custom_field = Trello::CustomField.find('5f60e443555b8432d959ae94', fields: 'name,type')
      expect(custom_field).to be_a(Trello::CustomField)

      expect(custom_field.id).not_to be_nil
      expect(custom_field.name).not_to be_nil
      expect(custom_field.type).not_to be_nil

      expect(custom_field.model_id).to be_nil
      expect(custom_field.model_type).to be_nil
      expect(custom_field.field_group).to be_nil
      expect(custom_field.enable_display_on_card).to be_nil
      expect(custom_field.position).to be_nil
    end
  end

end
