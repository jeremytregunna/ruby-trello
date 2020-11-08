module Trello
  # A custom field option contains the individual items in a custom field dropdown menu.
  #
  class CustomFieldOption < BasicDataAlpha

    schema do
      # Readonly
      attribute :id, remote_key: '_id', readonly: true, primary_key: true
      attribute :custom_field_id, remote_key: 'idCustomField', readonly: true

      # Writable but for create only
      attribute :value, create_only: true
      attribute :color, create_only: true
      attribute :position, remote_key: 'pos', create_only: true
    end

    validates_presence_of :id, :value

    def self.find(id, params = {})
      params = params.with_indifferent_access
      custom_field_id = params.delete(:custom_field_id)
      return if custom_field_id.nil?

      from_response client.get("/customFields/#{custom_field_id}/options/#{id}")
    end

    def delete
      client.delete(element_path)
    end

    def collection_path
      "/customFields/#{custom_field_id}/options"
    end

    def element_path
      "/customFields/#{custom_field_id}/options/#{id}"
    end
  end
end
