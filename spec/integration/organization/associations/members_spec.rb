require 'spec_helper'

RSpec.describe 'Trello::Organization#members' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get members' do
    VCR.use_cassette('can_get_members_of_organization') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      members = organization.members

      expect(members).to be_a(Array)
      expect(members[0]).to be_a(Trello::Member)
    end
  end

end
