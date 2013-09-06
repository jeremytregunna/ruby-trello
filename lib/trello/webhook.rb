module Trello
  # A webhook is an url called each time a specified idModel is updated
  class Webhook < BasicData
    register_attributes :id, :description, :id_model, :callback_url, :active,
      :readonly => [ :id ]
    validates_presence_of :id, :id_model, :callback_url
    validates_length_of   :description,  :in => 1..16384

    class << self
      # Find a specific webhook by its id.
      def find(id, params = {})
        client.find(:webhook, id, params)
      end

      # Create a new webhook and save it on Trello.
      def create(options)
        client.create(:webhook,
            'description' => options[:description],
            'idModel'     => options[:id_model],
            'callbackURL' => options[:callback_url])
      end
    end

    def update_fields(fields)
      attributes[:id]              = fields['id']
      attributes[:description]     = fields['description']
      attributes[:id_model]        = fields['idModel']
      attributes[:callback_url]    = fields['callbackURL']
      attributes[:active]          = fields['active']
      self
    end

    def save
      # If we have an id, just update our fields.
      return update! if id

      client.post("/webhooks", {
        :description => description,
        :idModel     => id_model,
        :callbackURL => callback_url
      }).json_into(self)
    end

    def update!
      client.put("/webhooks/#{id}", {
        :description => description,
        :idModel     => id_model,
        :callbackURL => callback_url,
        :active      => active
      })
    end

    # Delete this webhook
    def delete
      client.delete("/webhooks/#{id}")
    end

    # Check if the webhook is activated
    def activated?
      active
    end
  end
end
