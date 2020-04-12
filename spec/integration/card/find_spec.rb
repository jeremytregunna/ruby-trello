require 'spec_helper'

RSpec.describe 'Trello::Card#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('card_find_with_id_and_get_all_fields') do
      card = Trello::Card.find('5e9310df53f23017628a8011')
      expect(card).to be_a(Trello::Card)
      expect(card.id).to eq('5e9310df53f23017628a8011')
      expect(card.short_id).not_to be_nil
      expect(card.name).not_to be_nil
      expect(card.desc).not_to be_nil
      expect(card.due).not_to be_nil
      expect(card.due_complete).not_to be_nil
      expect(card.closed).not_to be_nil
      expect(card.url).not_to be_nil
      expect(card.short_url).not_to be_nil
      expect(card.board_id).not_to be_nil
      expect(card.member_ids).not_to be_nil
      expect(card.list_id).not_to be_nil
      expect(card.pos).not_to be_nil
      expect(card.last_activity_date).not_to be_nil
      expect(card.labels).not_to be_nil
      expect(card.card_labels).not_to be_nil
      expect(card.cover_image_id).not_to be_nil # only exist when the care use a custom cover image
      expect(card.badges).not_to be_nil

      expect(card.card_members).to be_nil # default not return members
      expect(card.source_card_id).to be_nil # it's params only work for create card
      expect(card.source_card_properties).to be_nil # it's params only work for creae card
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('card_find_with_id_and_get_specific_fields') do
      card = Trello::Card.find('5e7233b06b440f2b93a57b58', fields: 'desc,pos', members: true)
      expect(card).to be_a(Trello::Card)
      expect(card.id).to eq('5e7233b06b440f2b93a57b58')

      expect(card.desc).not_to be_nil
      expect(card.pos).not_to be_nil
      expect(card.card_members).not_to be_nil # default not return members

      expect(card.name).to be_nil
      expect(card.short_id).to be_nil
      expect(card.url).to be_nil
      expect(card.short_url).to be_nil
      expect(card.due).to be_nil
      expect(card.due_complete).to eq(false)
      expect(card.closed).to be_nil
      expect(card.board_id).to be_nil
      expect(card.member_ids).to be_nil
      expect(card.list_id).to be_nil
      expect(card.last_activity_date).to be_nil
      expect(card.labels).to eq([])
      expect(card.card_labels).to be_nil
      expect(card.cover_image_id).to be_nil # only exist when the care use a custom cover image
      expect(card.badges).to be_nil
      expect(card.source_card_id).to be_nil # it's params only work for create card
      expect(card.source_card_properties).to be_nil # it's params only work for creae card
    end
  end

end
