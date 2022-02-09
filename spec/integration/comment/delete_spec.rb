require 'spec_helper'

RSpec.describe 'Trello::Comment#delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can successfully delete a comment' do
    VCR.use_cassette('comment_delete') do
      comment = Trello::Comment.find('61faa73dd180eb86947af0fd')
      expect(comment.id).to eq('61faa73dd180eb86947af0fd')

      comment.delete
      expect {
        Trello::Comment.find('61faa73dd180eb86947af0fd')
      }.to raise_error("The requested resource was not found.")
    end
  end

end
