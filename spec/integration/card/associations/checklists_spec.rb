require 'spec_helper'

RSpec.describe 'Trello::Card#checklists' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get checklists' do
    VCR.use_cassette('get_checklists_of_card') do
      card = Trello::Card.find('5e946acb3cc40322434c214e')
      checklists = card.checklists
      expect(checklists.count).to be > 0
      expect(checklists[0]).to be_a(Trello::Checklist)
      expect(checklists[0].card_id).to eq(card.id)
    end
  end

end
