require 'spec_helper'

RSpec.describe 'Trell::Checklist.delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can delete an checklist' do
    VCR.use_cassette('can_success_delete_checklist') do
      checklist = Trello::Checklist.find('5f527c51adecdd18331874d5')

      checklist.delete

      expect{ Trello::Checklist.find('5f527c51adecdd18331874d5') }.to raise_error('The requested resource was not found.')
    end
  end
end
