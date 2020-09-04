require 'spec_helper'

RSpec.describe 'Trello::Checklist#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('checklist_find_with_id_and_get_all_fields') do
      checklist = Trello::Checklist.find('5f526c25f22acb4769d521ef')

      expect(checklist).to be_a(Trello::Checklist)
      expect(checklist.id).to eq('5f526c25f22acb4769d521ef')
      expect(checklist.name).not_to be_nil
      expect(checklist.position).not_to be_nil
      expect(checklist.check_items).not_to be_nil
      expect(checklist.board_id).not_to be_nil
      expect(checklist.card_id).not_to be_nil
    end
  end

end
