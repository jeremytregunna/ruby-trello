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
    register_attributes :id, :name, :closed, :board_id, :pos, readonly: [ :id, :board_id ]
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
            'name'    => options[:name],
            'idBoard' => options[:board_id])
      end
    end

    # Updates the fields of a list.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # a List.
    def update_fields(fields)
      attributes[:id]       = fields['id']
      attributes[:name]     = fields['name']
      attributes[:closed]   = fields['closed']
      attributes[:board_id] = fields['idBoard']
      attributes[:pos]      = fields['pos']
      self
    end

    def save
      return update! if id

      client.post("/lists", {
        name: name,
        closed: closed || false,
        idBoard: board_id
      }).json_into(self)
    end

    def update!
      client.put("/lists/#{id}", {
        name: name,
        closed: closed
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

    # :nodoc:
    def request_prefix
      "/lists/#{id}"
    end
  end
end
