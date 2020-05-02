require 'spec_helper'

RSpec.describe 'Trell::Card.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the card' do
    VCR.use_cassette('can_success_create_a_card') do
      card = Trello::Card.create(
        name: 'Test Trello::Card.create',
        list_id: '5e93bac014d40e501ee46b8d',
        desc: 'testing card create',
        member_ids: '5e679b808e6e8828784b30e1',
        card_labels: '5e93ba987669b2254983d69d,5e93ba987669b2254983d69e',
        due: '2020-12-22T01:59:00.000Z',
        due_complete: false,
        pos: 'top',
        source_card_id: '5e93ba665c58c44a46cb2ef9',
        source_card_properties: 'comments'
      )
      expect(card).to be_a(Trello::Card)

      expect(card.name).to eq('Test Trello::Card.create')
      expect(card.list_id).to eq('5e93bac014d40e501ee46b8d')
      expect(card.desc).to eq('testing card create')
      expect(card.member_ids).to eq(['5e679b808e6e8828784b30e1'])
      expect(card.labels.count).to eq(2)
      expect(card.due).to eq(Time.new(2020, 12, 22, 1, 59, 0, '+00:00'))
      expect(card.due_complete).to eq(false)
      expect(card.pos).not_to be_nil
      expect(card.source_card_id).to eq('5e93ba665c58c44a46cb2ef9')
      expect(card.source_card_properties).to eq('comments')

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

