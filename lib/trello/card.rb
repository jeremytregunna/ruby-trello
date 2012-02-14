module Trello
  # A Card is a container that can house checklists and comments; it resides inside a List.
  class Card < BasicData
    register_attributes :id, :short_id, :name, :description, :due, :closed, :url, :board_id, :member_ids, :list_id,
      :readonly => [ :id, :short_id, :url, :board_id, :member_ids ]
    validates_presence_of :id, :name, :list_id
    validates_length_of   :name,        :in => 1..16384
    validates_length_of   :description, :in => 0..16384

    include HasActions

    class << self
      # Find a specific card by its id.
      def find(id)
        super(:cards, id)
      end

      # Create a new card and save it on Trello.
      def create(options)
        new('name'   => options[:name],
            'idList' => options[:list_id],
            'desc'   => options[:description]).save
      end
    end

    # Update the fields of a card.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a card.
    def update_fields(fields)
      attributes[:id]          = fields['id']
      attributes[:short_id]    = fields['idShort']
      attributes[:name]        = fields['name']
      attributes[:description] = fields['desc']
      attributes[:due]         = Time.iso8601(fields['due']) rescue nil
      attributes[:closed]      = fields['closed']
      attributes[:url]         = fields['url']
      attributes[:board_id]    = fields['idBoard']
      attributes[:member_ids]  = fields['idMembers']
      attributes[:list_id]     = fields['idList']
      self
    end

    # Returns a reference to the board this card is part of.
    one :board, :using => :board_id

    # Returns a list of checklists associated with the card.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :all ] # default :all
    many :checklists, :filter => :all

    # Returns a reference to the list this card is currently in.
    one :list, :using => :list_id

    # Returns a list of members who are assigned to this card.
    def members
      members = member_ids.map do |member_id|
        Client.get("/members/#{member_id}").json_into(Member)
      end
      MultiAssociation.new(self, members).proxy
    end

    # Saves a record.
    def save
      # If we have an id, just update our fields.
      return update! if id

      Client.post("/cards", {
        :name   => name,
        :desc   => description,
        :idList => list_id
      }).json_into(self)
    end

    # Update an existing record.
    # Warning, this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    def update!
      @previously_changed = changes
      @changed_attributes.clear

      Client.put("/cards/#{id}", {
        :name      => name,
        :desc      => description,
        :due       => due && due.utc.iso8601,
        :closed    => closed,
        :idList    => list_id,
        :idBoard   => board_id,
        :idMembers => member_ids
      })
    end

    # Is the record valid?
    def valid?
      name && list_id
    end

    # Add a comment with the supplied text.
    def add_comment(text)
      Client.post("/cards/#{id}/actions/comments", :text => text)
    end

    # Add a checklist to this card
    def add_checklist(checklist)
      Client.post("/cards/#{id}/checklists", {
        :value => checklist.id
      })
    end

    # Retrieve a list of labels
    def labels
      labels = Client.get("/cards/#{id}/labels").json_into(Label)
      MultiAssociation.new(self, labels).proxy
    end

    # Add a label
    def add_label(colour)
      unless %w{green yellow orange red purple blue}.include? colour
        errors.add(:label, "colour '#{colour}' does not exist")
        return Trello.logger.warn "The label colour '#{colour}' does not exist."
      end
      Client.post("/cards/#{id}/labels", { :value => colour })
    end

    # Remove a label
    def remove_label(colour)
      unless %w{green yellow orange red purple blue}.include? colour
        errors.add(:label, "colour '#{colour}' does not exist")
        return Trello.logger.warn "The label colour '#{colour}' does not exist." unless %w{green yellow orange red purple blue}.include? colour
      end
      Client.delete("/cards/#{id}/labels/#{colour}")
    end

    # :nodoc:
    def request_prefix
      "/cards/#{id}"
    end

  end
end
