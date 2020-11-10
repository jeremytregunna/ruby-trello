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
  # @!attribute [r] creator_id,
  #   @return [String]
  class Notification < BasicData

    schema do
      # Readonly
      attribute :id, read_only: true
      attribute :type, read_only: true
      attribute :date, read_only: true
      attribute :data, read_only: true
      attribute :creator_app, read_only: true, remote_key: 'appCreator'
      attribute :creator_id, read_only: true, remote_key: 'idMemberCreator'
      attribute :action_id, read_only: true, remote_key: 'idAction'
      attribute :is_reactable, read_only: true, remote_key: 'isReactable'
      attribute :unread, read_only: true
      attribute :read_at, read_only: true, remote_key: 'dateRead'
      attribute :reactions, read_only: true
    end

    validates_presence_of :id, :type, :date, :creator_id

    alias :unread? :unread

    one :creator, path: :members, via: Member, using: :creator_id

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
