require 'spec_helper'

RSpec.describe 'Trello::Card#members' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get members' do
    VCR.use_cassette('get_members_of_card') do
      card = Trello::Card.find('5e946acb3cc40322434c214e')
      members = card.members
      expect(members.count).to be > 0
      expect(members[0]).to be_a(Trello::Member)
      expect(members[0].id).to be_in(card.member_ids)
    end
  end

end
