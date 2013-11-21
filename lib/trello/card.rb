module Trello
  # A Card is a container that can house checklists and comments; it resides inside a List.
  class Card < BasicData
    register_attributes :id, :short_id, :name, :desc, :due, :closed, :url, :board_id, :member_ids, :list_id, :pos, :last_activity_date,
      :readonly => [ :id, :short_id, :url, :last_activity_date ]
    validates_presence_of :id, :name, :list_id
    validates_length_of   :name,        :in => 1..16384
    validates_length_of   :desc, :in => 0..16384

    include HasActions

    SYMBOL_TO_STRING = {
      id: 'id',
      short_id: 'idShort',
      name: 'name',
      desc: 'desc',
      due: 'due',
      closed: 'closed',
      url: 'url',
      board_id: 'idBoard',
      member_ids: 'idMembers',
      list_id: 'idList',
      pos: 'pos',
      last_activity_date: 'dateLastActivity'
    }

    class << self
      # Find a specific card by its id.
      def find(id, params = {})
        client.find(:card, id, params)
      end

      # Create a new card and save it on Trello.
      def create(options)
        client.create(:card,
            'name' => options[:name],
            'idList' => options[:list_id],
            'desc'   => options[:desc],
            'idMembers' => options[:member_ids])
      end
    end

    # Update the fields of a card.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a card.
    def update_fields(fields)
      attributes[:id]                 = fields[SYMBOL_TO_STRING[:id]]
      attributes[:short_id]           = fields[SYMBOL_TO_STRING[:short_id]]
      attributes[:name]               = fields[SYMBOL_TO_STRING[:name]]
      attributes[:desc]               = fields[SYMBOL_TO_STRING[:desc]]
      attributes[:due]                = Time.iso8601(fields[SYMBOL_TO_STRING[:due]]) rescue nil
      attributes[:closed]             = fields[SYMBOL_TO_STRING[:closed]]
      attributes[:url]                = fields[SYMBOL_TO_STRING[:url]]
      attributes[:board_id]           = fields[SYMBOL_TO_STRING[:board_id]]
      attributes[:member_ids]         = fields[SYMBOL_TO_STRING[:member_ids]]
      attributes[:list_id]            = fields[SYMBOL_TO_STRING[:list_id]]
      attributes[:pos]                = fields[SYMBOL_TO_STRING[:post]]
      attributes[:last_activity_date] = Time.iso8601(fields[SYMBOL_TO_STRING[:last_activity_date]]) rescue nil
      self
    end

    # Returns a reference to the board this card is part of.
    one :board, :path => :boards, :using => :board_id

    # Returns a list of checklists associated with the card.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :all ] # default :all
    many :checklists, :filter => :all

    def check_item_states
      states = client.get("/cards/#{self.id}/checkItemStates").json_into(CheckItemState)
      MultiAssociation.new(self, states).proxy
    end


    # Returns a reference to the list this card is currently in.
    one :list, :path => :lists, :using => :list_id

    # Returns a list of members who are assigned to this card.
    def members
      members = member_ids.map do |member_id|
        client.get("/members/#{member_id}").json_into(Member)
      end
      MultiAssociation.new(self, members).proxy
    end

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      client.post("/cards", {
        name:   name,
        desc:   desc,
        idList: list_id,
        idMembers: member_ids
      }).json_into(self)
    end

    # Update an existing record.
    # Warning, this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/cards/#{id}", payload)
    end

    # Delete this card
    def delete
      client.delete("/cards/#{id}")
    end

    # Check if the card is not active anymore.
    def closed?
      closed
    end

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
      client.post("/cards/#{id}/actions/comments", :text => text)
    end

    # Add a checklist to this card
    def add_checklist(checklist)
      client.post("/cards/#{id}/checklists", {
        :value => checklist.id
      })
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
        payload = { :value => new_board.id }
        payload[:idList] = new_list.id if new_list
        client.put("/cards/#{id}/idBoard", payload)
      end
    end

    # Add a member to this card
    def add_member(member)
      client.post("/cards/#{id}/members", {
        :value => member.id
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
    def add_label(colour)
      unless %w{green yellow orange red purple blue}.include? colour
        errors.add(:label, "colour '#{colour}' does not exist")
        return Trello.logger.warn "The label colour '#{colour}' does not exist."
      end
      client.post("/cards/#{id}/labels", { :value => colour })
    end

    # Remove a label
    def remove_label(colour)
      unless %w{green yellow orange red purple blue}.include? colour
        errors.add(:label, "colour '#{colour}' does not exist")
        return Trello.logger.warn "The label colour '#{colour}' does not exist." unless %w{green yellow orange red purple blue}.include? colour
      end
      client.delete("/cards/#{id}/labels/#{colour}")
    end

    # Add an attachment to this card
    def add_attachment(attachment, name='')
      if attachment.is_a? File
        client.post("/cards/#{id}/attachments", {
            :file => attachment,
            :name => name
          })
      else
        client.post("/cards/#{id}/attachments", {
            :url => attachment,
            :name => name
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
