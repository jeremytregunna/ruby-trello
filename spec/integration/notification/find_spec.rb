require 'spec_helper'

RSpec.describe 'Trello::Notification#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with notification string' do
    VCR.use_cassette('notification_find_with_id') do
      notification = Trello::Notification.find('5fa890adbf71bd13269ffdc5')
      expect(notification).to be_a(Trello::Notification)

      expect(notification.id).not_to be_nil
      expect(notification.type).not_to be_nil
      expect(notification.date).not_to be_nil
      expect(notification.data).not_to be_nil
      # expect(notification.creator_app).not_to be_nil
      expect(notification.creator_id).not_to be_nil
      expect(notification.action_id).not_to be_nil
      expect(notification.is_reactable).not_to be_nil
      expect(notification.unread).not_to be_nil
      # expect(notification.read_at).not_to be_nil
      expect(notification.reactions).not_to be_nil
    end
  end

end
