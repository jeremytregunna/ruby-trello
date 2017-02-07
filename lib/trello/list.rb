module Trello
  # A List is a container which holds cards. Lists are items on a board.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] closed
  #   @return [Boolean]
  # @!attribute [r] board_id
  #   @return [String] A 24-character hex string
  # @!attribute [rw] pos
  #   @return [Object]
  class List < BasicData
    register_attributes :id, :name, :closed, :board_id, :pos, :source_list_id, readonly: [ :id, :board_id ]
    validates_presence_of :id, :name, :board_id
    validates_length_of   :name, in: 1..16384

    include HasActions

    class << self
      # Finds a specific list, given an id.
      #
      # @param [id] id the list's ID on Trello (24-character hex string).
      # @param [Hash] params
      def find(id, params = {})
        client.find(:list, id, params)
      end

      def create(options)
        client.create(:list,
            'name'         => options[:name],
            'idBoard'      => options[:board_id],
            'pos'          => options[:pos],
            'idListSource' => options[:source_list_id])
      end
    end

    # Updates the fields of a list.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a List.
    def update_fields(fields)
      attributes[:id]             = fields['id'] || attributes[:id]
      attributes[:name]           = fields['name'] || fields[:name] || attributes[:name]
      attributes[:closed]         = fields['closed'] if fields.has_key?('closed')
      attributes[:board_id]       = fields['idBoard'] || fields[:board_id] || attributes[:board_id]
      attributes[:pos]            = fields['pos'] || fields[:pos] || attributes[:pos]
      attributes[:source_list_id] = fields['idListSource'] || fields[:source_list_id] || attributes[:source_list_id]
      self
    end

    def save
      return update! if id

      from_response client.post("/lists", {
        name: name,
        closed: closed || false,
        idBoard: board_id,
        pos: pos,
        idListSource: source_list_id
      })
    end

    def update!
      client.put("/lists/#{id}", {
        name: name,
        closed: closed,
        pos: pos
      })
    end

    # Check if the list is not active anymore.
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

    # Return the board the list is connected to.
    one :board, path: :boards, using: :board_id

    # Returns all the cards on this list.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :cards, filter: :open

    def move_all_cards(other_list)
      client.post("/lists/#{id}/moveAllCards", {
        idBoard: other_list.board_id,
        idList: other_list.id
       })
    end

    # Archives all the cards of the list
    def archive_all_cards
      client.post("/lists/#{id}/archiveAllCards")
    end

    # :nodoc:
    def request_prefix
      "/lists/#{id}"
    end
  end
end
