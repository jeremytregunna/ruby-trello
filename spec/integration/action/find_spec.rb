require 'spec_helper'

RSpec.describe 'Trello::Action#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('action_find_with_id_and_get_all_fields') do
      action = Trello::Action.find('5f60f07958388d26dc063c30')
      expect(action).to be_a(Trello::Action)

      expect(action.id).to eq('5f60f07958388d26dc063c30')
      expect(action.creator_id).not_to be_nil
      expect(action.data).not_to be_nil
      expect(action.type).not_to be_nil
      expect(action.date).not_to be_nil
      expect(action.limits).not_to be_nil
      expect(action.display).not_to be_nil
    end
  end

end
