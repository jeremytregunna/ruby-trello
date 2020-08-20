require 'spec_helper'

RSpec.describe 'Trello::Member#notifications' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get notifications' do
    VCR.use_cassette('can_get_notifications_of_member') do
      member = Trello::Member.find('hoppertest')
      notifications = member.notifications

      expect(notifications).to be_a(Array)
      expect(notifications[0]).to be_a(Trello::Notification)
    end
  end

end
