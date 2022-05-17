require 'spec_helper'

RSpec.describe 'Trello::Card#add_member' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can add a member to a card' do
    VCR.use_cassette('can_add_a_member_to_a_card') do
      member = Trello::Member.new('id' => '5e679b808e6e8828784b30e1')
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
      response = card.add_member(member)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body.first['id']).to eq('5e679b808e6e8828784b30e1')
    end
  end
end
