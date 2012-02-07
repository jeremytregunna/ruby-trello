module Trello
  class Notification < BasicData
    attr_reader :id, :unread, :type, :date, :data, :member_creator_id

    class << self
      # Locate a notification by its id
      def find(id)
        super(:notifications, id)
      end
    end

    def update_fields(fields)
      @id                = fields['id']
      @unread            = fields['unread']
      @type              = fields['type']
      @date              = fields['date']
      @data              = fields['data']
      @member_creator_id = fields['idMemberCreator']
      self
    end

    alias :unread? :unread

    def member_creator
      Member.find(member_creator_id)
    end

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