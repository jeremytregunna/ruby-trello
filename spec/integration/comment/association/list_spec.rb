require 'spec_helper'

RSpec.describe 'Trello::Comment#list' do
  include IntegrationHelpers

  before { setup_trello }

  it "can get the comment's list" do
    VCR.use_cassette('can_get_comments_list') do
      comment = Trello::Comment.new(id: "61faa73dd180eb86947af0fd")

      list = comment.list
      expect(list.id).not_to be_nil
    end
  end

end
