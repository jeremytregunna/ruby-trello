module Trello
  # An Item is a basic task that can be checked off and marked as completed.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] name
  #   @return [String]
  # @!attribute [r] type
  #   @return [Object]
  # @!attribute [r] state
  #   @return [Object]
  # @!attribute [r] pos
  #   @return [Object]
  class Item < BasicData

    schema do
      # Readonly
      attribute :id, readonly: true, primary_key: true
      attribute :type, readonly: true
      attribute :name_data, readonly: true, remote_key: 'nameData'
      attribute :due_date, readonly: true, remote_key: 'due', serializer: 'Time'
      attribute :member_id, readonly: true, remote_key: 'idMember'
      attribute :state, readonly: true
      attribute :checklist_id, readonly: true, remote_key: 'idChecklist'

      # Writable and write only
      attribute :name, write_only: true
      attribute :position, write_only: true, remote_key: 'pos'
      attribute :checked, write_only: true
    end

    validates_presence_of :id

    def complete?
      state == "complete"
    end
  end
end
