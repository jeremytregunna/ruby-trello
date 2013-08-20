module Trello
  # A webhook is an url called each time a specified idModel is updated
  class Webhook < BasicData
    register_attributes :id, :description, :idModel, :callbackURL, :active,
      :readonly => [ :id ]
    validates_presence_of :id, :idModel, :callbackURL
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
            'idModel'     => options[:idModel],
            'callbackURL' => options[:callbackURL])
      end
    end

    def update_fields(fields)
      attributes[:id]              = fields['id']
      attributes[:description]     = fields['description']
      attributes[:idModel]         = fields['idModel']
      attributes[:callbackURL]     = fields['callbackURL']
      attributes[:active]          = fields['active']
      self
    end

    def save
      # If we have an id, just update our fields.
      return update! if id

      client.post("/webhooks", {
        :description => description,
        :idModel     => idModel,
        :callbackURL => callbackURL
      }).json_into(self)
    end

    def update!
      client.put("/webhooks/#{id}", {
        :description => description,
        :idModel     => idModel,
        :callbackURL => callbackURL,
        :active      => active
      })
    end

    # Delete this webhook
    def delete
      client.delete("/webhooks/#{id}")
    end
  end
end
