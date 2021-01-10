require 'spec_helper'

RSpec.describe 'Trello::Organization.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the organization' do
    VCR.use_cassette('can_success_create_a_organization') do
      organization = Trello::Organization.create(
        name: 'integrationtest98',
        display_name: 'Integration Test 98',
        description: 'This is a team for doing integration tests.'
      )
      expect(organization).to be_a(Trello::Organization)

      expect(organization.id).not_to be_nil
      expect(organization.name).to eq('integrationtest98')
      expect(organization.display_name).to eq('Integration Test 98')
      expect(organization.description).to eq('This is a team for doing integration tests.')
    end
  end
end
