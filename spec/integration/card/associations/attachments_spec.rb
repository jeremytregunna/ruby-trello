require 'spec_helper'

RSpec.describe 'Trello::Card#attachments' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get attachments' do
    VCR.use_cassette('can_get_attachments') do
      card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')

      attachments = card.attachments
      expect(attachments).to be_a(Array)
      expect(attachments[0]).to be_a(Trello::Attachment)
    end
  end

end
