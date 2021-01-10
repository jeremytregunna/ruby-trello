require 'spec_helper'

RSpec.describe 'Trello::List#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('list_find_with_id_and_get_all_fields') do
      list = Trello::List.find('5e93ba4fe51ee2602ec671af')
      expect(list).to be_a(Trello::List)
      expect(list.id).to eq('5e93ba4fe51ee2602ec671af')
      expect(list.name).not_to be_nil
      expect(list.pos).not_to be_nil
      expect(list.board_id).not_to be_nil
      expect(list.source_list_id).to be_nil
      expect(list.closed).not_to be_nil
      expect(list.subscribed).to be_nil
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('list_find_with_id_and_get_specific_fields') do
      list = Trello::List.find('5e93ba4fe51ee2602ec671af', fields: 'name,pos')
      expect(list).to be_a(Trello::List)
      expect(list.id).to eq('5e93ba4fe51ee2602ec671af')
      expect(list.name).not_to be_nil
      expect(list.pos).not_to be_nil

      expect(list.board_id).to be_nil
      expect(list.source_list_id).to be_nil
      expect(list.closed).to be_nil
      expect(list.subscribed).to be_nil
    end
  end

end
