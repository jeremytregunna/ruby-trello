require 'spec_helper'

RSpec.describe 'Trello::Comment#board' do
  include IntegrationHelpers

  before { setup_trello }

  it "can get the comment's board" do
    VCR.use_cassette('can_get_comments_board') do
      comment = Trello::Comment.new(id: "61faa73dd180eb86947af0fd")

      board = comment.board
      expect(board.id).not_to be_nil
    end
  end

end
