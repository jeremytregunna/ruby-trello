require 'spec_helper'

RSpec.describe 'Trello::Organization#boards' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get boards' do
    VCR.use_cassette('can_get_boards_of_organization') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      boards = organization.boards

      expect(boards).to be_a(Array)
      expect(boards[0]).to be_a(Trello::Board)
      boards.each do |board|
        expect(board.id).not_to be_nil
        expect(board.name).not_to be_nil
        expect(board.pinned).not_to be_nil
        expect(board.url).not_to be_nil
      end
    end
  end

  it 'can get boards with filter and specific fields' do
    VCR.use_cassette('can_get_boards_with_filter_of_organization') do
      organization = Trello::Organization.find('5e93ba154634282b6df23bcc')
      boards = organization.boards(filter: "open", fields: "id,name")

      expect(boards).to be_a(Array)
      expect(boards[0]).to be_a(Trello::Board)
      boards.each do |board|
        expect(board.id).not_to be_nil
        expect(board.name).not_to be_nil
        expect(board.pinned).to be_nil
        expect(board.url).to be_nil
      end
    end
  end

end
