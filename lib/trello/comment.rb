module Trello
  # A Comment is a string with a creation date; it resides inside a Card and belongs to a User.
  #
  # @!attribute [r] action_id
  #   @return [String]
  # @!attribute [r] text
  #   @return [String]
  # @!attribute [r] date
  #   @return [Datetime]
  # @!attribute [r] member_creator_id
  #   @return [String]
  class Comment < BasicData
    register_attributes :action_id, :text, :date, :member_creator_id,
      readonly: [ :action_id, :text, :date, :member_creator_id ]
    validates_presence_of :action_id, :text, :date, :member_creator_id
    validates_length_of   :text,        in: 1..16384

    class << self
      # Locate a specific action and return a new Comment object.
      def find(action_id)
        client.find(:action, action_id, filter: commentCard)
      end
    end

    # Update the attributes of a Comment
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a Comment.
    def update_fields(fields)
      attributes[:action_id]          = fields['id'] || attributes[:action_id]
      attributes[:text]               = fields['data']['text'] || attributes[:text]
      attributes[:date]               = Time.iso8601(fields['date']) if fields.has_key?('date')
      attributes[:member_creator_id]  = fields['idMemberCreator'] || attributes[:member_creator_id]
      self
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
    one :member_creator, via: Member, path: :members, using: :member_creator_id
  end
end
