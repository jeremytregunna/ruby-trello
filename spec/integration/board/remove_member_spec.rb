require 'spec_helper'

RSpec.describe 'Trello::Board#remove_member' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success remove a member from a board' do
    VCR.use_cassette('can_success_remove_member_from_board') do
      member = Trello::Member.new('id' => 'wokenqingtian')
      card = Trello::Board.find('5e93ba98614ac22d22f085c4')
      response = card.remove_member(member)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['members'].count).to eq(1)
      expect(body['members'][0]['username']).not_to eq('wokenqingtian')
    end
  end

end
