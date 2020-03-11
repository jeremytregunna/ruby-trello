require 'spec_helper'

RSpec.describe 'Board - Lists API' do

  before do
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY'] || 'developerpublickey'
      config.member_token = ENV['TRELLO_MEMBER_TOKEN'] || 'membertoken'
    end
  end

  it 'AssociationProxy#to_a, #to_ary' do
    VCR.use_cassette('get_lists') do
      board = Trello::Board.find('5e679be40c407034b479459c')
      lists = board.lists
      expect(lists.to_a).to be_a(Array)
      expect(lists.to_ary).to be_a(Array)
    end
  end

end
