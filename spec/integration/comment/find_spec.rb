require 'spec_helper'

RSpec.describe 'Trello::Comment#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('comment_find_with_id') do
      comment = Trello::Comment.find('61faa73dd180eb86947af0fd')

      expect(comment).to be_a(Trello::Comment)
      expect(comment.id).to eq('61faa73dd180eb86947af0fd')
    end
  end

end
