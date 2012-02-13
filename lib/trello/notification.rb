module Trello
  class Notification < BasicData
    register_attributes :id, :unread, :type, :date, :data, :member_creator_id,
      :read_only => [ :id, :unread, :type, :date, :member_creator_id ]
    validates_presence_of :id, :type, :date, :member_creator_id

    class << self
      # Locate a notification by its id
      def find(id)
        super(:notifications, id)
      end
    end

    def update_fields(fields)
      attributes[:id]                = fields['id']
      attributes[:unread]            = fields['unread']
      attributes[:type]              = fields['type']
      attributes[:date]              = fields['date']
      attributes[:data]              = fields['data']
      attributes[:member_creator_id] = fields['idMemberCreator']
      self
    end

    alias :unread? :unread

    one :member_creator, :via => Member, :using => :member_creator_id

    def board
      Client.get("/notifications/#{id}/board").json_into(Board)
    end

    def list
      Client.get("/notifications/#{id}/list").json_into(List)
    end

    def card
      Client.get("/notifications/#{id}/card").json_into(Card)
    end

    def member
      Client.get("/notifications/#{id}/member").json_into(Member)
    end

    def organization
      Client.get("/notifications/#{id}/organization").json_into(Organization)
    end
  end
end