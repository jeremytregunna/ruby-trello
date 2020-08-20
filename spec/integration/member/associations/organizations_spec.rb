require 'spec_helper'

RSpec.describe 'Trello::Member#organizations' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get organizations' do
    VCR.use_cassette('can_get_organizations_of_member') do
      member = Trello::Member.find('hoppertest')
      organizations = member.organizations

      expect(organizations).to be_a(Array)
      expect(organizations[0]).to be_a(Trello::Organization)
    end
  end

end
