module Trello
  class Token < BasicData
    register_attributes :id, :member_id, :created_at, :permissions,
      :readonly => [ :id, :member_id, :created_at, :permissions ]

    class << self
      # Finds a token
      def find(token, params = {})
        client.find(:token, token, params)
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
    one :member, :path => :members, :using => :member_id
  end
end
