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
  class Webhook < BasicData
    register_attributes :id, :description, :id_model, :callback_url, :active,
      readonly: [ :id ]
    validates_presence_of :id, :id_model, :callback_url
    validates_length_of   :description,  in: 1..16384

    class << self
      # Find a specific webhook by its ID.
      #
      # @raise [Trello::Error] if a Webhook with the given ID can't be found.
      # @return [Trello::Webhook] the Webhook with the given ID.
      def find(id, params = {})
        client.find(:webhook, id, params)
      end

      # Create a new webhook and save it to Trello.
      #
      # @param [Hash] options
      #
      # @option options [String] :description (optional) A string with a length from 0 to 16384
      # @option options [String] :callback_url (required) A valid URL that is
      #    reachable with a HEAD request
      # @option options [String] :id_model (required) id of the model that should be hooked
      #
      # @raise [Trello::Error] if the Webhook could not be created.
      #
      # @return [Trello::Webhook]
      def create(options)
        client.create(:webhook,
            'description' => options[:description],
            'idModel'     => options[:id_model],
            'callbackURL' => options[:callback_url])
      end
    end

    # @return [Trello::Webhook] self
    def update_fields(fields)
      attributes[:id]              = fields['id']
      attributes[:description]     = fields['description']
      attributes[:id_model]        = fields['idModel']
      attributes[:callback_url]    = fields['callbackURL']
      attributes[:active]          = fields['active']
      self
    end

    # Save the webhook.
    #
    # @raise  [Trello::Error] if the Webhook could not be saved.
    #
    # @return [String] the JSON representation of the saved webhook.
    def save
      # If we have an id, just update our fields.
      return update! if id

      client.post("/webhooks", {
        description: description,
        idModel: id_model,
        callbackURL: callback_url
      }).json_into(self)
    end

    # Update the webhook.
    #
    # @raise  [Trello::Error] if the Webhook could not be saved.
    #
    # @return [String] the JSON representation of the updated webhook.
    def update!
      client.put("/webhooks/#{id}", {
        description: description,
        idModel: id_model,
        callbackURL: callback_url,
        active: active
      })
    end

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
