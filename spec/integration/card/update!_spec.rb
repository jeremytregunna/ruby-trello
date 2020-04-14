require 'spec_helper'

RSpec.describe 'Trell::Card.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a card' do
    VCR.use_cassette('can_success_update_bong_a_card') do
      card = Trello::Card.find('5e94fd9443f25a7263b165d0')
      expect(card.name).to eq('C1')
      expect(card.desc).to eq('')
      expect(card.member_ids).to eq([])
      expect(card.card_labels).to eq([])
      expect(card.due).to be_nil
      expect(card.due_complete).to eq(false)
      expect(card.list_id).to eq('5e94eafdf553d46ea525faa7')

      card.name = 'Test Trello::Card.update!'
      card.list_id = '5e94fa1248c5e41ad0464a7f'
      card.desc =  'testing card update!'
      card.member_ids = '5e679b808e6e8828784b30e1'
      card.card_labels = '5e94eaf37669b225494161c7'
      card.due = '2020-12-22T01:59:00.000Z'
      card.due_complete = false
      card.pos = 'top'

      card.update!

      expect(card.name).to eq('Test Trello::Card.update!')
      expect(card.list_id).to eq('5e94fa1248c5e41ad0464a7f')
      expect(card.desc).to eq('testing card update!')
      expect(card.member_ids).to eq(['5e679b808e6e8828784b30e1'])
      expect(card.card_labels.count).to eq(1)
      expect(card.due).to eq(Time.new(2020, 12, 22, 1, 59, 0, '+00:00'))
      expect(card.due_complete).to eq(false)
      expect(card.pos).not_to be_nil

      expect(card.id).not_to be_nil
      expect(card.short_id).not_to be_nil
      expect(card.closed).not_to be_nil
      expect(card.url).not_to be_nil
      expect(card.short_url).not_to be_nil
      expect(card.board_id).not_to be_nil
      expect(card.last_activity_date).not_to be_nil
      expect(card.card_labels).not_to be_nil
      expect(card.badges).not_to be_nil
      expect(card.card_members).to be_nil # default not return members
      expect(card.cover_image_id).to be_nil # only exist when the care use a custom cover image
    end
  end

end
