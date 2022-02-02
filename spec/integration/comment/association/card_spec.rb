require 'spec_helper'

RSpec.describe 'Trello::Comment#card' do
  include IntegrationHelpers

  before { setup_trello }

  it "can get the comment's card" do
    VCR.use_cassette('can_get_comments_card') do
      comment = Trello::Comment.new(id: "61faa73dd180eb86947af0fd")

      card = comment.card
      expect(card.id).not_to be_nil
    end
  end

end
