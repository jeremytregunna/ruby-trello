require 'spec_helper'

RSpec.describe 'Trell::List.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a list with all fields' do
    VCR.use_cassette('can_success_update_bong_a_list') do
      list = Trello::List.find('5f52526dd20e29822abc6eca')

      expect(list.name).to eq('L3')

      list.name = 'L3 - Changed'
      list.board_id = '5e93ba98614ac22d22f085c4'
      list.pos = 'top'
      list.closed = false
      list.subscribed = true

      list.update!

      expect(list.name).to eq('L3 - Changed')
      expect(list.closed).to eq(false)
      expect(list.subscribed).to be_nil
      expect(list.board_id).to eq('5e93ba98614ac22d22f085c4')
    end
  end

  it 'can update! a list with specific fields' do
    VCR.use_cassette('can_success_update_bong_a_list_with_specific_fields') do
      list = Trello::List.find('5f52526dd20e29822abc6eca')

      expect(list.closed).to eq(false)

      list.closed = true

      list.update!

      list = Trello::List.find('5f52526dd20e29822abc6eca')
      expect(list.closed).to eq(true)
    end
  end
end
