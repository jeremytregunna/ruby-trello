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
  class Token < BasicDataAlpha

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :identifier, readonly: true
      attribute :member_id, readonly: true, remote_key: 'idMember'
      attribute :created_at, readonly: true, remote_key: 'dateCreated', serializer: 'Time'
      attribute :expires_at, readonly: true, remote_key: 'dateExpires', serializer: 'Time'
      attribute :permissions, readonly: true
      attribute :webhooks, readonly: true, default: [], serializer: 'Webhooks'
    end

    class << self
      # Finds a token
      def find(token, params = {webhooks: true})
        client.find(:token, token, params)
      end
    end

    # Returns a reference to the user who authorized the token.
    one :member, path: :members, using: :member_id
  end
end
