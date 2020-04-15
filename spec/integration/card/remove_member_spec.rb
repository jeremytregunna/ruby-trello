require 'spec_helper'

RSpec.describe 'Trello::Card#remove_member' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can remove a member to a card' do
    VCR.use_cassette('can_remove_a_member_from_a_card') do
      member = Trello::Member.new('id' => '5e679b808e6e8828784b30e1')
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
      response = card.remove_member(member)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body).to be_a(Array)
    end
  end
end
