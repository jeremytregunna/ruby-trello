module Trello
  class Token < BasicData
    register_attributes :id, :member_id, :created_at, :permissions,
      :readonly => [ :id, :member_id, :created_at, :permissions ]
  
    class << self
      # Finds a token
      def find(token)
        super(:tokens, token)
      end
    end

    # :nodoc:
    def update_fields(fields)
      attributes[:id]          = fields['id']
      attributes[:member_id]   = fields['idMember']
      attributes[:created_at]  = Time.iso8601(fields['dateCreated'])
      attributes[:permissions] = fields['permissions'] || {}
    end

    # Returns a reference to the user who authorized the token.
    one :member, :using => :member_id
  end
end