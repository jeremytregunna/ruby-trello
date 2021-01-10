require 'spec_helper'

RSpec.describe 'Trello::Checklist.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the checklist partial parameters' do
    VCR.use_cassette('can_success_create_a_checklist') do
      checklist = Trello::Checklist.create(
        name: 'C2',
        card_id: '5e94fd9443f25a7263b165d0'
      )

      expect(checklist).to be_a(Trello::Checklist)
      expect(checklist.name).to eq('C2')
      expect(checklist.id).not_to be_nil
      expect(checklist.position).not_to be_nil
      expect(checklist.card_id).to eq('5e94fd9443f25a7263b165d0')
    end
  end

end
