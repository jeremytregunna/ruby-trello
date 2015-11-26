module Trello

  # @!attribute [r] id
  #   @return [String]
  # @!attribute [rw] unread
  #   @return [Boolean]
  # @!attribute [r] type
  #   @return [Object]
  # @!attribute [r] date
  #   @return [Datetime]
  # @!attribute [rw] data
  #   @return [Object]
  # @!attribute [r] member_creator_id,
  #   @return [String]
  class Notification < BasicData
    register_attributes :id, :unread, :type, :date, :data, :member_creator_id,
      read_only: [ :id, :unread, :type, :date, :member_creator_id ]
    validates_presence_of :id, :type, :date, :member_creator_id

    class << self
      # Locate a notification by its id
      def find(id, params = {})
        client.find(:notification, id, params)
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

    one :member_creator, path: :members, via: Member, using: :member_creator_id

    def board
      Board.from_response client.get("/notifications/#{id}/board")
    end

    def list
      List.from_response client.get("/notifications/#{id}/list")
    end

    def card
      Card.from_response client.get("/notifications/#{id}/card")
    end

    def member
      Member.from_response client.get("/notifications/#{id}/member")
    end

    def organization
      Organization.from_response client.get("/notifications/#{id}/organization")
    end
  end
end
