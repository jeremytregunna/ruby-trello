module Trello

  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] member_id
  #   @return [String]
  # @!attribute [r] created_at
  #   @return [Datetime]
  # @!attribute [r] permissions
  #   @return [Object]
  # @!attribute [r] webhooks
  #   @return [Object]
  class Token < BasicData
    register_attributes :id, :member_id, :created_at, :permissions, :webhooks,
      readonly: [ :id, :member_id, :created_at, :permissions, :webhooks ]

    class << self
      # Finds a token
      def find(token, params = {webhooks: true})
        client.find(:token, token, params)
      end
    end

    # :nodoc:
    def update_fields(fields)
      attributes[:id]          = fields['id'] || attributes[:id]
      attributes[:member_id]   = fields['idMember'] || attributes[:member_id]
      attributes[:created_at]  = Time.iso8601(fields['dateCreated']) rescue nil if fields.has_key?('dateCreated')
      attributes[:permissions] = fields['permissions'] || attributes[:permissions]
      attributes[:permissions] ||= {}
      attributes[:webhooks]    = fields['webhooks'] || attributes[:webhooks]
    end

    # Returns a reference to the user who authorized the token.
    one :member, path: :members, using: :member_id
  end
end
