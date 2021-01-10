require 'spec_helper'

RSpec.describe 'Trello::Organization#actions' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get actions' do
    VCR.use_cassette('can_get_actions_of_organization') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      actions = organization.actions

      expect(actions).to be_a(Array)
      expect(actions[0]).to be_a(Trello::Action)
    end
  end

end
