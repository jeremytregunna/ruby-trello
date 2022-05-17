require 'spec_helper'

RSpec.describe 'Trello::Card#move_to_board' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can move a card to another board without specific the target list' do
    VCR.use_cassette('can_move_a_card_to_another_board_without_specific_list') do
      board = Trello::Board.find('5e94ee7357ac8a3edc2b2145')
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
      response = card.move_to_board(board)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['id']).to eq('5e95d1b4f43f9a06497f17f7')
      expect(body['idBoard']).to eq('5e94ee7357ac8a3edc2b2145')
      expect(body['idList']).not_to be_nil
    end
  end

  it 'can move a card to another board with a specific target list' do
    VCR.use_cassette('can_move_a_card_to_another_board_with_specific_list') do
      board = Trello::Board.find('5e94f5ded016b22c2437c13c')
      list = Trello::List.find('5e95d1b07f2ff83927319128')
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
      response = card.move_to_board(board, list)

      expect(response.code).to eq(200)
      body = JSON.parse(response.body)
      expect(body['id']).to eq('5e95d1b4f43f9a06497f17f7')
      expect(body['idBoard']).to eq('5e94f5ded016b22c2437c13c')
      expect(body['idList']).to eq('5e95d1b07f2ff83927319128')
    end
  end
end
