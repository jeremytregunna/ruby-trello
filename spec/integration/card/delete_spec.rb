require 'spec_helper'

RSpec.describe 'Trello::Card#delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success delete card' do
    VCR.use_cassette('can_success_delete_card') do
      card = Trello::Card.find('5e95b664ace3621af695aeb0')
      respone = card.delete
      expect(respone.code).to eq(200)
    end
  end

end
