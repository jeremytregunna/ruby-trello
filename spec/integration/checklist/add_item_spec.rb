require 'spec_helper'

RSpec.describe 'Trello::Checklist.add_item' do
  include IntegrationHelpers

  before { setup_trello }

  it 'checklist can add an item' do
    VCR.use_cassette('checklist_can_add_an_item') do
      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.check_items.count).to eq(0)

      checklist.add_item('A')

      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.check_items.count).to eq(1)
    end
  end

end
