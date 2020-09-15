require 'spec_helper'

RSpec.describe 'Trello::Organization#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('organization_find_with_id_and_get_all_fields') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      expect(organization).to be_a(Trello::Organization)

      expect(organization.id).not_to be_nil
      expect(organization.name).not_to be_nil
      expect(organization.display_name).not_to be_nil
      expect(organization.team_type).not_to be_nil
      expect(organization.description).not_to be_nil
      expect(organization.url).not_to be_nil
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('organization_find_with_id_and_get_specific_fields') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc', fields: 'name,url')
      expect(organization).to be_a(Trello::Organization)

      expect(organization.id).not_to be_nil
      expect(organization.name).not_to be_nil
      expect(organization.url).not_to be_nil

      expect(organization.display_name).to be_nil
      expect(organization.team_type).to be_nil
      expect(organization.description).to be_nil
    end
  end

end
