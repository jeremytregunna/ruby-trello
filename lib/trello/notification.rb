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
  # @!attribute [r] creator_id
  #   @return [String]
  # @!attribute [r] creator_app
  #   @return [String]
  # @!attribute [r] action_id
  #   @return [String]
  # @!attribute [r] is_reactable
  #   @return [Boolean]
  # @!attribute [r] read_at
  #   @return [Datetime]
  # @!attribute [r] reactions
  #   @return [Array]
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

    def board(params = {})
      Board.from_response client.get("/notifications/#{id}/board", params)
    end

    def list(params = {})
      List.from_response client.get("/notifications/#{id}/list", params)
    end

    def card(params = {})
      Card.from_response client.get("/notifications/#{id}/card", params)
    end

    def member(params = {})
      Member.from_response client.get("/notifications/#{id}/member", params)
    end

    def organization(params = {})
      Organization.from_response client.get("/notifications/#{id}/organization", params)
    end
  end
end
