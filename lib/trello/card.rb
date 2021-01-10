module Trello
  # A Card is a container that can house checklists and comments; it resides inside a List.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] short_id
  #   @return [Fixnum]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] desc
  #   @return [String]
  # @!attribute [rw] due
  #   @return [Datetime]
  # @!attribute [rw] closed
  #   @return [Boolean]
  # @!attribute [r] url
  #   @return [String]
  # @!attribute [r] short_url
  #   @return [String]
  # @!attribute [rw] board_id
  #   @return [String] A 24-character hex string
  # @!attribute [rw] member_ids
  #   @return [Array<String>] An Array of 24-character hex strings
  # @!attribute [rw] list_id
  #   @return [String] A 24-character hex string
  # @!attribute [rw] pos
  #   @return [Float]
  # @!attribute [r] last_activity_date
  #   @return [Dateime]
  # @!attribute [rw] card_labels
  #   @return [Array<Hash>]
  # @!attribute [rw] labels
  #   @return [Array<Trello::Labels>]
  # @!attribute [rw] cover_image_id
  #   @return [String] A 24-character hex string
  # @!attribute [r] badges
  #   @return [Hash]
  # @!attribute [r] card_members
  #   @return [Object]
  # @!attribute [rw] source_card_id
  #   @return [String] A 24-character hex string
  # @!attribute [rw] source_card_properties
  #   @return [Array<String>] Array of strings

  class Card < BasicData
    schema do
      # readonly
      attribute :id, readonly: true, primary_key: true
      attribute :short_id, readonly: true, remote_key: 'idShort'
      attribute :url, readonly: true
      attribute :short_url, readonly: true, remote_key: 'shortUrl'
      attribute :last_activity_date, readonly: true, remote_key: 'dateLastActivity', serializer: 'Time'
      attribute :labels, readonly: true, default: [], serializer: 'Labels'
      attribute :badges, readonly: true
      attribute :card_members, readonly: true, remote_key: 'members'

      # Writable
      attribute :name
      attribute :desc
      attribute :due, serializer: 'Time'
      attribute :due_complete, remote_key: 'dueComplete'
      attribute :member_ids, remote_key: 'idMembers'
      attribute :list_id, remote_key: 'idList'
      attribute :pos
      attribute :card_labels, remote_key: 'idLabels'

      # Writable but for create only
      attribute :source_card_id, create_only: true, remote_key: 'idCardSource'
      attribute :keep_from_source, create_only: true, remote_key: 'keepFromSource'

      # Writable but for update only
      attribute :closed, update_only: true
      attribute :board_id, update_only: true, remote_key: 'idBoard'
      attribute :cover_image_id, update_only: true, remote_key: 'idAttachmentCover'

      # Deprecated
      attribute :source_card_properties, create_only: true, remote_key: 'keepFromSource'
    end

    validates_presence_of :id, :name, :list_id
    validates_length_of   :name, in: 1..16384
    validates_length_of   :desc, in: 0..16384

    include HasActions

    # Returns a reference to the board this card is part of.
    one :board, path: :boards, using: :board_id

    # Returns a reference to the cover image attachment
    def cover_image(params = {})
      response = client.get("/cards/#{id}/attachments/#{cover_image_id}", params)
      CoverImage.from_response(response)
    end

    # Returns a list of checklists associated with the card.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :all ] # default :all
    many :checklists, filter: :all

    # Returns a list of plugins associated with the card
    many :plugin_data, path: "pluginData"

    # List of custom field values on the card, only the ones that have been set
    many :custom_field_items, path: 'customFieldItems'

    def check_item_states
      states = CheckItemState.from_response client.get("/cards/#{self.id}/checkItemStates")
      MultiAssociation.new(self, states).proxy
    end

    # Returns a reference to the list this card is currently in.
    one :list, path: :lists, using: :list_id

    # Returns a list of members who are assigned to this card.
    #
    # @return [Array<Trello::Member>]
    def members
      members = Member.from_response client.get("/cards/#{self.id}/members")
      MultiAssociation.new(self, members).proxy
    end

    # Returns a list of members who have upvoted this card
    # NOTE: this fetches a list each time it's called to avoid case where
    # card is voted (or vote is removed) after card is fetched. Optimizing
    # accuracy over network performance
    #
    # @return [Array<Trello::Member>]
    def voters
      Member.from_response client.get("/cards/#{id}/membersVoted")
    end

    # Delete this card
    #
    # @return [String] the JSON response from the Trello API
    def delete
      client.delete("/cards/#{id}")
    end

    # Check if the card is not active anymore.
    def closed?
      closed
    end

    # Close the card.
    #
    # This only marks your local copy card as closed. Use `close!` if you
    # want to close the card and persist the change to the Trello API.
    #
    # @return [Boolean] always returns true
    #
    # @return [String] The JSON representation of the closed card returned by
    #     the Trello API.
    def close
      self.closed = true
    end

    def close!
      close
      save
    end

    # Is the record valid?
    def valid?
      !(name && list_id).nil?
    end

    # Add a comment with the supplied text.
    def add_comment(text)
      client.post("/cards/#{id}/actions/comments", text: text)
    end

    # Add a checklist to this card
    def add_checklist(checklist, name: nil, position: nil)
      payload = { idChecklistSource: checklist.id }
      payload[:name] = name if name 
      payload[:pos] = position if position

      client.post("/cards/#{id}/checklists", payload)
    end

    # create a new checklist and add it to this card
    def create_new_checklist(name)
      client.post("/cards/#{id}/checklists", { name: name })
    end

    # Move this card to the given list
    def move_to_list(list)
      list_number = list.is_a?(String) ? list : list.id
      unless list_id == list_number
        client.put("/cards/#{id}/idList", {
          value: list_number
        })
      end
    end

    # Moves this card to the given list no matter which board it is on
    def move_to_list_on_any_board(list_id)
      list = List.find(list_id)
      if board.id == list.board_id
        move_to_list(list_id)
      else
        move_to_board(Board.find(list.board_id), list)
      end
    end

    # Move this card to the given board (and optional list on this board)
    def move_to_board(new_board, new_list = nil)
      unless board_id == new_board.id
        payload = { value: new_board.id }
        payload[:idList] = new_list.id if new_list
        client.put("/cards/#{id}/idBoard", payload)
      end
    end

    # Add a member to this card
    def add_member(member)
      client.post("/cards/#{id}/idMembers", {
        value: member.id
      })
    end

    # Remove a member from this card
    def remove_member(member)
      client.delete("/cards/#{id}/idMembers/#{member.id}")
    end

    # Current authenticated user upvotes a card
    def upvote
      begin
        client.post("/cards/#{id}/membersVoted", {
          value: me.id
        })
      rescue Trello::Error => e
        fail e unless e.message =~ /has already voted/i
      end

      self
    end

    # Recind upvote. Noop if authenticated user hasn't previously voted
    def remove_upvote
      begin
        client.delete("/cards/#{id}/membersVoted/#{me.id}")
      rescue Trello::Error => e
        fail e unless e.message =~ /has not voted/i
      end

      self
    end

    # Add a label
    def add_label(label)
      unless label.valid?
        errors.add(:label, "is not valid.")
        return Trello.logger.warn "Label is not valid." unless label.valid?
      end
      client.post("/cards/#{id}/idLabels", {value: label.id})
    end

    # Remove a label
    def remove_label(label)
      unless label.valid?
        errors.add(:label, "is not valid.")
        return Trello.logger.warn "Label is not valid." unless label.valid?
      end
      client.delete("/cards/#{id}/idLabels/#{label.id}")
    end

    # Add an attachment to this card
    def add_attachment(attachment, name = '')
      # Is it a file object or a string (url)?
      if attachment.respond_to?(:path) && attachment.respond_to?(:read)
        client.post("/cards/#{id}/attachments", {
            file: attachment,
            name: name
          })
      else
        client.post("/cards/#{id}/attachments", {
            url: attachment,
            name: name
          })
      end
    end

    # Retrieve a list of attachments
    def attachments
      attachments = Attachment.from_response client.get("/cards/#{id}/attachments")
      MultiAssociation.new(self, attachments).proxy
    end

    # Remove an attachment from this card
    def remove_attachment(attachment)
      client.delete("/cards/#{id}/attachments/#{attachment.id}")
    end

    # :nodoc:
    def request_prefix
      "/cards/#{id}"
    end

    # Retrieve a list of comments
    def comments
      comments = Comment.from_response client.get("/cards/#{id}/actions", filter: "commentCard")
    end

    # Find the creation date
    def created_at
      @created_at ||= Time.at(id[0..7].to_i(16)) rescue nil
    end

    private

    def me
      @me ||= Member.find(:me)
    end

  end
end
