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
  # @!attribute [rw] cover_image_id
  #   @return [String] A 24-character hex string
  # @!attribute [r] badges
  #   @return [Hash]
  # @!attribute [r] card_members
  #   @return [Object]
  class Card < BasicData
    register_attributes :id, :short_id, :name, :desc, :due, :closed, :url, :short_url,
      :board_id, :member_ids, :list_id, :pos, :last_activity_date, :card_labels,
      :cover_image_id, :badges, :card_members,
      readonly: [ :id, :short_id, :url, :short_url, :last_activity_date, :badges, :card_members ]
    validates_presence_of :id, :name, :list_id
    validates_length_of   :name,        in: 1..16384
    validates_length_of   :desc, in: 0..16384

    include HasActions

    SYMBOL_TO_STRING = {
      id: 'id',
      short_id: 'idShort',
      name: 'name',
      desc: 'desc',
      due: 'due',
      closed: 'closed',
      url: 'url',
      short_url: 'shortUrl',
      board_id: 'idBoard',
      member_ids: 'idMembers',
      cover_image_id: 'idAttachmentCover',
      list_id: 'idList',
      pos: 'pos',
      last_activity_date: 'dateLastActivity',
      card_labels: 'labels',
      badges: 'badges',
      card_members: 'members'
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
      # @param [Hash] options # @option options [String] :name The name of the new card.
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
          'labels' => options[:card_labels],
          'due' => options[:due],
          'pos' => options[:pos]
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
    # @option fields [Boolean] :closed
    # @option fields [String] :url
    # @option fields [String] :short_url
    # @option fields [String] :board_id
    # @option fields [String] :member_ids A comma-separated list of objectIds
    #     (24-character hex strings).
    # @option fields [String] :pos A position. `"top"`, `"bottom"`, or a
    #     positive number. Defaults to `"bottom"`.
    # @option fields [String] :card_labels A comma-separated list of
    #     objectIds (24-character hex strings).
    # @option fields [Object] :cover_image_id
    # @option fields [Object] :badges
    # @option fields [Object] :card_members
    #
    # @return [Trello::Card] self
    def update_fields(fields)
      attributes[:id]                 = fields[SYMBOL_TO_STRING[:id]]
      attributes[:short_id]           = fields[SYMBOL_TO_STRING[:short_id]]
      attributes[:name]               = fields[SYMBOL_TO_STRING[:name]]
      attributes[:desc]               = fields[SYMBOL_TO_STRING[:desc]]
      attributes[:due]                = Time.iso8601(fields[SYMBOL_TO_STRING[:due]]) rescue nil
      attributes[:closed]             = fields[SYMBOL_TO_STRING[:closed]]
      attributes[:url]                = fields[SYMBOL_TO_STRING[:url]]
      attributes[:short_url]          = fields[SYMBOL_TO_STRING[:short_url]]
      attributes[:board_id]           = fields[SYMBOL_TO_STRING[:board_id]]
      attributes[:member_ids]         = fields[SYMBOL_TO_STRING[:member_ids]]
      attributes[:list_id]            = fields[SYMBOL_TO_STRING[:list_id]]
      attributes[:pos]                = fields[SYMBOL_TO_STRING[:pos]]
      attributes[:card_labels]        = fields[SYMBOL_TO_STRING[:card_labels]]
      attributes[:last_activity_date] = Time.iso8601(fields[SYMBOL_TO_STRING[:last_activity_date]]) rescue nil
      attributes[:cover_image_id]     = fields[SYMBOL_TO_STRING[:cover_image_id]]
      attributes[:badges]             = fields[SYMBOL_TO_STRING[:badges]]
      attributes[:card_members]       = fields[SYMBOL_TO_STRING[:card_members]]
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

    def check_item_states
      states = client.get("/cards/#{self.id}/checkItemStates").json_into(CheckItemState)
      MultiAssociation.new(self, states).proxy
    end


    # Returns a reference to the list this card is currently in.
    one :list, path: :lists, using: :list_id

    # Returns a list of members who are assigned to this card.
    #
    # @return [Array<Trello::Member>]
    def members
      members = member_ids.map do |member_id|
        client.get("/members/#{member_id}").json_into(Member)
      end
      MultiAssociation.new(self, members).proxy
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

      client.post("/cards", {
        name:   name,
        desc:   desc,
        idList: list_id,
        idMembers: member_ids,
        labels: card_labels,
        pos: pos
      }).json_into(self)
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
      @changed_attributes.clear

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

    # Retrieve a list of labels
    def labels
      labels = client.get("/cards/#{id}/labels").json_into(Label)
      MultiAssociation.new(self, labels).proxy
    end
    
    # Add a label
    def add_label(value)
      if value.is_a? String
        colour = value 
        unless Label.label_colours.include? colour
          errors.add(:label, "colour '#{colour}' does not exist")
          return Trello.logger.warn "The label colour '#{colour}' does not exist."
        end
        client.post("/cards/#{id}/labels", { value: colour })
      elsif value.is_a? Label
        client.post("/cards/#{id}/idLabels", {value: value.id})
      end
    end

    # Remove a label
    def remove_label(value)
      if value.is_a? String
        colour = value 
        unless Label.label_colours.include? colour
          errors.add(:label, "colour '#{colour}' does not exist")
          return Trello.logger.warn "The label colour '#{colour}' does not exist." unless Label.label_colours.include? colour
        end
        client.delete("/cards/#{id}/labels/#{colour}")
      elsif value.is_a? Label
        client.delete("/cards/#{id}/idLabels/#{value.id}")
      end
    end

    # Add an attachment to this card
    def add_attachment(attachment, name='')
      if attachment.is_a? File
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
      attachments = client.get("/cards/#{id}/attachments").json_into(Attachment)
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
  end
end
