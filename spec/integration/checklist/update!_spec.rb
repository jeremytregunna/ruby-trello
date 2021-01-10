require 'spec_helper'

RSpec.describe 'Trell::Checklist.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a checklist with specific fields' do
    VCR.use_cassette('can_success_update_bong_a_checklist_with_specific_fields') do
      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.name).to eq('C2')

      checklist.name = 'C2 - Changed'

      checklist.update!

      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')
      expect(checklist.name).to eq('C2 - Changed')
    end
  end
end
