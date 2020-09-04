require 'spec_helper'

RSpec.describe 'Trell::List.save' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the list' do
    VCR.use_cassette('can_success_create_a_list') do
      list = Trello::List.new(
        name: 'L3',
        board_id: '5e94eaf386374970d06e4c89'
      )
      list.save

      expect(list).to be_a(Trello::List)
      expect(list.name).to eq('L3')
      expect(list.id).not_to be_nil
      expect(list.pos).not_to be_nil
      expect(list.closed).to eq(false)
      expect(list.board_id).to eq('5e94eaf386374970d06e4c89')
      expect(list.subscribed).to be_nil
    end
  end

  it 'can success update a list' do
    VCR.use_cassette('can_success_upate_a_list') do
      list = Trello::List.find('5f52526ebda8ea4a96445dbf')
      expect(list.name).to eq('L4')

      list.name = 'L4 - Changed'
      list.save

      list = Trello::List.find('5f52526ebda8ea4a96445dbf')
      expect(list.name).to eq('L4 - Changed')
    end
  end

end

