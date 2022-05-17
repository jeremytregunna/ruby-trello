require 'spec_helper'

RSpec.describe 'Trell::Card#add_comment' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can add a comment to a card' do
    VCR.use_cassette('can_success_add_comment_to_a_card') do
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')
      response = card.add_comment('Hello, world!')

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['type']).to eq('commentCard')
      expect(body['data']['text']).to eq('Hello, world!')
    end
  end
end
