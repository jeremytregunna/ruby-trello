require 'spec_helper'

RSpec.describe 'Trello::Card#actions' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get actions' do
    VCR.use_cassette('can_get_actions') do
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      actions = card.actions
      expect(actions.count).to be > 0
      expect(actions[0]).to be_a(Trello::Action)
    end
  end

end
