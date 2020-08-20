require 'spec_helper'

RSpec.describe 'Trello::Member#actions' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get actions' do
    VCR.use_cassette('can_get_actions_of_members') do
      member = Trello::Member.find('hoppertest')
      actions = member.actions

      expect(actions).to be_a(Array)
      expect(actions[0]).to be_a(Trello::Action)
    end
  end
end
