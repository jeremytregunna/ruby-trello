require 'spec_helper'

RSpec.describe 'Trello::Checklist.update_item_state' do
  include IntegrationHelpers

  before { setup_trello }

  it 'checklist can update and item state' do
    VCR.use_cassette('checklist_can_update_the_item_state') do
      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.check_items.first['state']).to eq('incomplete')

      checklist.update_item_state('5f527dd00ac0cb4a43d85be7', 'complete')

      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.check_items.first['state']).to eq('complete')
    end
  end

end
