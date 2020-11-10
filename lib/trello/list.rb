# frozen_string_literal: true

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
  # @!attribute [w] source_list_id
  #   @return [String]
  # @!attribute [w] subscribed
  #   @return [Boolean]
  class List < BasicData
    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true

      # Writable
      attribute :name
      attribute :pos
      attribute :board_id, remote_key: 'idBoard'

      # Writable but for create only
      attribute :source_list_id, create_only: true, remote_key: 'idListSource'

      # Writable but for update only
      attribute :closed, update_only: true
      attribute :subscribed, update_only: true
    end

    validates_presence_of :id, :name, :board_id
    validates_length_of   :name, in: 1..16_384

    include HasActions

    class << self
      # Finds a specific list, given an id.
      #
      # @param [id] id the list's ID on Trello (24-character hex string).
      # @param [Hash] params
      def find(id, params = {})
        client.find(:list, id, params)
      end
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

    # Move list to another board. Accepts a `Trello::Board` or an id string.
    def move_to_board(board)
      board = board.id unless board.is_a?(String)

      client.put("/lists/#{id}/idBoard", value: board)
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
