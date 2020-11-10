module Trello
  # A Comment is a string with a creation date; it resides inside a Card and belongs to a User.
  #
  # @!attribute [r] action_id
  #   @return [String]
  # @!attribute [r] text
  #   @return [String]
  # @!attribute [r] date
  #   @return [Datetime]
  # @!attribute [r] creator_id
  #   @return [String]
  class Comment < BasicData

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :creator_id, readonly: true, remote_key: 'idMemberCreator'
      attribute :data, readonly: true
      attribute :type, readonly: true
      attribute :date, readonly: true, serializer: 'Time'
      attribute :limits, readonly: true
      attribute :app_creator, readonly: true, remote_key: 'appCreator'
      attribute :display, readonly: true

      # Writable
      attribute :text, update_only: true
    end

    validates_presence_of :action_id, :text, :date, :creator_id
    validates_length_of   :text,        in: 1..16384

    class << self
      def find(action_id)
        client.find(:action, action_id)
      end
    end

    # Returns the board this comment is located
    def board
      Board.from_response client.get("/actions/#{action_id}/board")
    end

    # Returns the card the comment is located
    def card
      Card.from_response client.get("/actions/#{action_id}/card")
    end

    # Returns the list the comment is located
    def list
      List.from_response client.get("/actions/#{action_id}/list")
    end

    # Deletes the comment from the card
    def delete
      ruta = "/actions/#{action_id}"
      client.delete(ruta)
    end

    # Returns the member who created the comment.
    one :member_creator, via: Member, path: :members, using: :creator_id
  end
end
