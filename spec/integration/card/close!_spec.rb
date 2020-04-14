require 'spec_helper'

RSpec.describe 'Trell::Card#close!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can close! a card' do
    VCR.use_cassette('can_close_bong_a_card') do
      card = Trello::Card.find('5e95bab4e5c5a66526f74278')
      card.close!
      expect(card.closed).to eq(true)
    end
  end

end
