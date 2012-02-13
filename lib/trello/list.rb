module Trello
  # A List is a container which holds cards. Lists are items on a board.
  class List < BasicData
    register_attributes :id, :name, :closed, :board_id, :readonly => [ :id, :board_id ]
    validates_presence_of :id, :name, :board_id
    validates_length_of   :name, :in => 1..16384

    include HasActions

    class << self
      # Finds a specific list, given an id.
      def find(id)
        super(:lists, id)
      end

      def create(options)
        new('name'    => options[:name],
            'idBoard' => options[:board_id]).save!
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
      self
    end

    def save
      return update! if id

      Client.post("/lists", {
        :name    => name,
        :closed  => closed || false,
        :idBoard => board_id
      }).json_into(self)
    end

    def update!
      Client.put("/lists", {
        :name   => name,
        :closed => closed
      }).json_into(self)
    end

    # Check if the list is not active anymore.
    def closed?
      closed
    end

    # Return the board the list is connected to.
    one :board, :using => :board_id

    # Returns all the cards on this list.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    many :cards, :filter => :open

    # :nodoc:
    def request_prefix
      "/lists/#{id}"
    end
  end
end
