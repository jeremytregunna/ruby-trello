module Trello
  # A Member is a user of the Trello service.
  class Member < BasicData
    include ActiveModel::Validations
    include ActiveModel::Dirty #changed?
    include ActiveModel::Serializers::JSON

    validates_presence_of :id, :username

    # These are the attributes which are exposed to this model.
    def self.attribute_names
      [ :id, :username, :full_name, :gravatar_id, :bio, :url ]
    end

    define_attribute_methods attribute_names

    class << self
      # Finds a user
      #
      # The argument may be specified as either an _id_ or a _username_.
      def find(id_or_username)
        super(:members, id_or_username)
      end
    end

    # Defines the attribute getter and setters.
    class_eval do
      attribute_names.each do |key|
        define_method(:"#{key}") { @attributes[key] }

        define_method :"#{key}=" do |val|
          send(:"#{key}_will_change!") unless val == @attributes[key]
          @attributes[key] = val
        end
      end
    end

    # Update the fields of a member.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an Member.
    def update_fields(fields)
      attributes
      attributes[:id]          = fields['id']
      attributes[:full_name]   = fields['fullName']
      attributes[:username]    = fields['username']
      attributes[:gravatar_id] = fields['gravatar']
      attributes[:bio]         = fields['bio']
      attributes[:url]         = fields['url']
      self
    end

    # Returns a list of the users actions.
    def actions
      return @actions if @actions
      @actions = Client.get("/members/#{username}/actions").json_into(Action)
    end

    # Returns a list of the boards a member is a part of.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #   :filter => [ :none, :members, :organization, :public, :open, :closed, :all ] # default: :all
    def boards(options = { :filter => :all })
      return @boards if @boards
      @boards = Client.get("/members/#{username}/boards", options).json_into(Board)
    end

    # Returns a list of cards the member is assigned to.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    def cards(options = { :filter => :open })
      return @cards if @cards
      @cards = Client.get("/members/#{username}/cards", options).json_into(Card)
    end

    # Returns a list of the organizations this member is a part of.
    #
    # The options hash may have a filter key which can have its value set as any
    # of the following values:
    #   :filter => [ :none, :members, :public, :all ] # default: all
    def organizations(options = { :filter => :all })
      return @organizations if @organizations
      @organizations = Client.get("/members/#{username}/organizations", options).json_into(Organization)
    end

    # Returns a list of notifications for the user
    def notifications
      Client.get("/members/#{username}/notifications").json_into(Notification)
    end

    def attributes
      @attributes ||= {
        :id          => @id,
        :full_name   => @full_name,
        :username    => @username,
        :gravatar_id => @gravatar_id,
        :bio         => @bio,
        :url         => @url
      }
    end

    def save
      @previously_changed = changes
      @changed_attributes.clear

      # TODO: updating attributes.
    end
  end
end
