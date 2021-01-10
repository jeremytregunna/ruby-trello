require 'spec_helper'

RSpec.describe 'Trello::List#actions' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get actions' do
    VCR.use_cassette('can_get_actions_of_list') do
      list = Trello::List.find('5f52526ebda8ea4a96445dbf')
      actions = list.actions

      expect(actions).to be_a(Array)
      expect(actions[0]).to be_a(Trello::Action)
    end
  end

end
