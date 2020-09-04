require 'spec_helper'

RSpec.describe 'Trello::List.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the list partial parameters' do
    VCR.use_cassette('can_success_create_a_list') do
      list = Trello::List.create(
        name: 'L3',
        board_id: '5e94eaf386374970d06e4c89'
      )
      expect(list).to be_a(Trello::List)

      expect(list.name).to eq('L3')
      expect(list.id).not_to be_nil
      expect(list.pos).not_to be_nil
      expect(list.closed).to eq(false)
      expect(list.board_id).to eq('5e94eaf386374970d06e4c89')
      expect(list.subscribed).to be_nil
    end
  end

  it 'can success create list with full parameters' do
    VCR.use_cassette('can_success_create_a_list_with_full_parameters') do
      list = Trello::List.create(
        name: 'L4',
        pos: 'top',
        board_id: '5e94eaf386374970d06e4c89',
        source_list_id: '5e93ba98614ac22d22f085c4'
      )
      expect(list).to be_a(Trello::List)

      expect(list.name).to eq('L4')
      expect(list.id).not_to be_nil
      expect(list.pos).not_to be_nil
      expect(list.closed).to eq(false)
      expect(list.board_id).to eq('5e94eaf386374970d06e4c89')
      expect(list.subscribed).to be_nil
    end
  end

end
