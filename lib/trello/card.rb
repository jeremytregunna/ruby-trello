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
    register_attributes :id, :short_id, :name, :desc, :due, :due_complete, :closed, :url, :short_url,
      :board_id, :member_ids, :list_id, :pos, :last_activity_date, :labels, :card_labels,
      :cover_image_id, :badges, :card_members, :source_card_id, :source_card_properties,
      readonly: [ :id, :short_id, :url, :short_url, :last_activity_date, :badges, :card_members ]
    validates_presence_of :id, :name, :list_id
    validates_length_of   :name, in: 1..16384
    validates_length_of   :desc, in: 0..16384

    include HasActions

    SYMBOL_TO_STRING = {
      id: 'id',
      short_id: 'idShort',
      name: 'name',
      desc: 'desc',
      due: 'due',
      due_complete: 'dueComplete',
      closed: 'closed',
      url: 'url',
      short_url: 'shortUrl',
      board_id: 'idBoard',
      member_ids: 'idMembers',
      cover_image_id: 'idAttachmentCover',
      list_id: 'idList',
      pos: 'pos',
      last_activity_date: 'dateLastActivity',
      card_labels: 'idLabels',
      labels: 'labels',
      badges: 'badges',
      card_members: 'members',
      source_card_id: "idCardSource",
      source_card_properties: "keepFromSource"
    }

    class << self
      # Find a specific card by its id.
      #
      # @raise [Trello::Error] if the card could not be found.
      #
      # @return [Trello::Card]
      def find(id, params = {})
        client.find(:card, id, params)
      end

      # Create a new card and save it on Trello.
      #
      # If using source_card_id to duplicate a card, make sure to save
      # the source card to Trello before calling this method to assure
      # the correct data is used in the duplication.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the new card.
      # @option options [String] :list_id ID of the list that the card should
      #     be added to.
      # @option options [String] :desc A string with a
      #     length from 0 to 16384.
      # @option options [String] :member_ids A comma-separated list of
      #     objectIds (24-character hex strings).
      # @option options [String] :card_labels A comma-separated list of
      #     objectIds (24-character hex strings).
      # @option options [Date] :due A date, or `nil`.
      # @option options [String] :pos A position. `"top"`, `"bottom"`, or a
      #     positive number. Defaults to `"bottom"`.
      # @option options [String] :source_card_id ID of the card to copy
      # @option options [String] :source_card_properties A single, or array of,
      #     string properties to copy from source card.
      #     `"all"`, `"checklists"`, `"due"`, `"members"`, or `nil`.
      #     Defaults to `"all"`.
      #
      # @raise [Trello::Error] if the card could not be created.
      #
      # @return [Trello::Card]
      def create(options)
        client.create(:card,
          'name' => options[:name],
          'idList' => options[:list_id],
          'desc'   => options[:desc],
          'idMembers' => options[:member_ids],
          'idLabels' => options[:card_labels],
          'due' => options[:due],
          'due_complete' => options[:due_complete] || false,
          'pos' => options[:pos],
          'idCardSource' => options[:source_card_id],
          'keepFromSource' => options.key?(:source_card_properties) ? options[:source_card_properties] : 'all'
        )
      end
    end

    # Update the fields of a card.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a card.
    #
    # Note that this this method does not save anything new to the Trello API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Trello.
    #
    # @param [Hash] fields
    # @option fields [String] :id
    # @option fields [String] :short_id
    # @option fields [String] :name The new name of the card.
    # @option fields [String] :desc A string with a length from 0 to
    #     16384.
    # @option fields [Date] :due A date, or `nil`.
    # @option fields [Boolean] :due_complete
    # @option fields [Boolean] :closed
    # @option fields [String] :url
    # @option fields [String] :short_url
    # @option fields [String] :board_id
    # @option fields [String] :member_ids A comma-separated list of objectIds
    #     (24-character hex strings).
    # @option fields [String] :pos A position. `"top"`, `"bottom"`, or a
    #     positive number. Defaults to `"bottom"`.
    # @option fields [Array]  :labels An Array of Trello::Label objects
    #     derived from the JSON response
    # @option fields [String] :card_labels A comma-separated list of
    #     objectIds (24-character hex strings).
    # @option fields [Object] :cover_image_id
    # @option fields [Object] :badges
    # @option fields [Object] :card_members
    # @option fields [String] :source_card_id
    # @option fields [Array]  :source_card_properties
    #
    # @return [Trello::Card] self
    def update_fields(fields)
      attributes[:id]                     = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      attributes[:short_id]               = fields[SYMBOL_TO_STRING[:short_id]] || attributes[:short_id]
      attributes[:name]                   = fields[SYMBOL_TO_STRING[:name]] || fields[:name] || attributes[:name]
      attributes[:desc]                   = fields[SYMBOL_TO_STRING[:desc]] || fields[:desc] || attributes[:desc]
      attributes[:due]                    = Time.iso8601(fields[SYMBOL_TO_STRING[:due]]) rescue nil if fields.has_key?(SYMBOL_TO_STRING[:due])
      attributes[:due]                    = fields[:due] if fields.has_key?(:due)
      attributes[:due_complete]           = fields[SYMBOL_TO_STRING[:due_complete]] if fields.has_key?(SYMBOL_TO_STRING[:due_complete])
      attributes[:due_complete]           ||= false
      attributes[:closed]                 = fields[SYMBOL_TO_STRING[:closed]] if fields.has_key?(SYMBOL_TO_STRING[:closed])
      attributes[:url]                    = fields[SYMBOL_TO_STRING[:url]] || attributes[:url]
      attributes[:short_url]              = fields[SYMBOL_TO_STRING[:short_url]] || attributes[:short_url]
      attributes[:board_id]               = fields[SYMBOL_TO_STRING[:board_id]] || attributes[:board_id]
      attributes[:member_ids]             = fields[SYMBOL_TO_STRING[:member_ids]] || fields[:member_ids] || attributes[:member_ids]
      attributes[:list_id]                = fields[SYMBOL_TO_STRING[:list_id]] || fields[:list_id] || attributes[:list_id]
      attributes[:pos]                    = fields[SYMBOL_TO_STRING[:pos]] || fields[:pos] || attributes[:pos]
      attributes[:labels]                 = (fields[SYMBOL_TO_STRING[:labels]] || []).map { |lbl| Trello::Label.new(lbl) }.presence || attributes[:labels].presence || []
      attributes[:card_labels]            = fields[SYMBOL_TO_STRING[:card_labels]] || fields[:card_labels] || attributes[:card_labels]
      attributes[:last_activity_date]     = Time.iso8601(fields[SYMBOL_TO_STRING[:last_activity_date]]) rescue nil if fields.has_key?(SYMBOL_TO_STRING[:last_activity_date])
      attributes[:cover_image_id]         = fields[SYMBOL_TO_STRING[:cover_image_id]] || attributes[:cover_image_id]
      attributes[:badges]                 = fields[SYMBOL_TO_STRING[:badges]] || attributes[:badges]
      attributes[:card_members]           = fields[SYMBOL_TO_STRING[:card_members]] || attributes[:card_members]
      attributes[:source_card_id]         = fields[SYMBOL_TO_STRING[:source_card_id]] || fields[:source_card_id] || attributes[:source_card_id]
      attributes[:source_card_properties] = fields[SYMBOL_TO_STRING[:source_card_properties]] || fields[:source_card_properties] || attributes[:source_card_properties]
      self
    end

    # Returns a reference to the board this card is part of.
    one :board, path: :boards, using: :board_id
    # Returns a reference to the cover image attachment
    one :cover_image, path: :attachments, using: :cover_image_id

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

    # Saves a record.
    #
    # @raise [Trello::Error] if the card could not be saved
    #
    # @return [String] The JSON representation of the saved card returned by
    #     the Trello API.
    def save
      # If we have an id, just update our fields.
      return update! if id

      from_response client.post("/cards", {
        name:   name,
        desc:   desc,
        idList: list_id,
        idMembers: member_ids,
        idLabels: card_labels,
        pos: pos,
        due: due,
        dueComplete: due_complete,
        idCardSource: source_card_id,
        keepFromSource: source_card_properties
      })
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Trello::Error] if the card could not be updated.
    #
    # @return [String] The JSON representation of the updated card returned by
    #     the Trello API.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.try(:clear)
      changes_applied if respond_to?(:changes_applied)

      client.put("/cards/#{id}", payload)
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
      name && list_id
    end

    # Add a comment with the supplied text.
    def add_comment(text)
      client.post("/cards/#{id}/actions/comments", text: text)
    end

    # Add a checklist to this card
    def add_checklist(checklist)
      client.post("/cards/#{id}/checklists", {
        value: checklist.id
      })
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
      client.post("/cards/#{id}/members", {
        value: member.id
      })
    end

    # Remove a member from this card
    def remove_member(member)
      client.delete("/cards/#{id}/members/#{member.id}")
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
