module Trello

  # A colored Label attached to a card
  #
  # @!attribute [rw] id
  #   @return [String]
  # @!attribute [rw] color
  #   @return [String]
  class Label < BasicData

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true

      # Writable
      attribute :name
      attribute :color

      # Writable but for create only
      attribute :board_id, create_only: true, remote_key: 'idBoard'
    end

    validates_presence_of :id, :board_id, :name
    validates_length_of :name, in: 1..16384

    # Returns a reference to the board this label is currently connected.
    one :board, path: :boards, using: :board_id

    # Delete this label
    def delete
      client.delete("/labels/#{id}")
    end

  end
end
