require 'spec_helper'

RSpec.describe 'Trello::Board#add_member' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can add a member to a board' do
    VCR.use_cassette('can_add_a_member_to_a_board') do
      member = Trello::Member.new('id' => 'wokenqingtian')
      card = Trello::Board.find('5e93ba98614ac22d22f085c4')
      response = card.add_member(member)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['id']).to eq('5e93ba98614ac22d22f085c4')
      expect(body['members'][0]['username']).to eq('wokenqingtian') 
    end
  end

end
