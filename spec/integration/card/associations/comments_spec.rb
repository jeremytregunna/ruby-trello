require 'spec_helper'

RSpec.describe 'Trello::Card#comments' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get comments' do
    VCR.use_cassette('can_get_comments') do
      card = Trello::Card.find('5e93ba665c58c44a46cb2ef9')

      comments = card.comments
      expect(comments).to be_a(Array)
      expect(comments[0]).to be_a(Trello::Comment)
    end
  end

end

