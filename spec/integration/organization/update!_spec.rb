require 'spec_helper'

RSpec.describe 'Trell::Organization.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a organization' do
    VCR.use_cassette('can_success_update_bong_a_organization') do
      organization = Trello::Organization.find('5f60d9f72c17b23dbb2d9d79')

      expect(organization.name).to eq('integrationtest98')
      expect(organization.display_name).to eq('Integration Test 98')
      expect(organization.description).to eq('This is a team for doing integration tests.')

      organization.name = 'integrationtest99'
      organization.display_name = 'Integration Test 99'
      organization.description = 'This is a team for doing integration tests for 99'

      organization.update!

      expect(organization.name).to eq('integrationtest99')
      expect(organization.display_name).to eq('Integration Test 99')
      expect(organization.description).to eq('This is a team for doing integration tests for 99')
    end
  end

end
