module Trello
  # A webhook is a URL called each time a specified model is updated
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] description
  #   @return [String]
  # @!attribute [r] id_model
  #   @return [String] A 24-character hex string
  # @!attribute [r] callback_url
  #   @return [String]
  # @!attribute [r] active
  #   @return [Boolean]
  class Webhook < BasicDataAlpha

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :consecutive_failures, readonly: true, remote_key: 'consecutiveFailures'
      attribute :first_consecutive_fail_date, readonly: true, remote_key: 'firstConsecutiveFailDate', serializer: 'Time'

      # Writable
      attribute :description
      attribute :model_id, remote_key: 'idModel'
      attribute :callback_url, remote_key: 'callbackURL'
      attribute :active
    end

    validates_presence_of :id, :model_id, :callback_url
    validates_length_of :description, in: 1..16384

    # Delete this webhook
    #
    # @return [String] the JSON response from the Trello API
    def delete
      client.delete("/webhooks/#{id}")
    end

    # Check if the webhook is activated
    #
    # @return [Boolean]
    def activated?
      active
    end
  end
end
