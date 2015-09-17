module Trello
  # A Member is a user of the Trello service.
  #
  # @!attribute [r] id
  #   @return [String]
  # @!attribute [r] username
  #   @return [String]
  # @!attribute [rw] email
  #   @return [String]
  # @!attribute [rw] full_name
  #   @return [String]
  # @!attribute [rw] initials
  #   @return [String]
  # @!attribute [r] avatar_id
  #   @return [String]
  # @!attribute [rw] bio
  #   @return [String]
  # @!attribute [r] url
  #   @return [String]
  class Member < BasicData
    register_attributes :id, :username, :email, :full_name, :initials, :avatar_id, :bio, :url, readonly: [ :id, :username, :avatar_id, :url ]
    validates_presence_of :id, :username
    validates_length_of   :full_name, minimum: 4
    validates_length_of   :bio,       maximum: 16384

    include HasActions

    class << self
      # Finds a user
      #
      # The argument may be specified as either an _id_ or a _username_.
      def find(id_or_username, params = {})
        client.find(:member, id_or_username, params)
      end
    end

    # Update the fields of a member.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an Member.
    def update_fields(fields)
      attributes[:id]        = fields['id']
      attributes[:full_name] = fields['fullName']
      attributes[:email]     = fields['email']
      attributes[:username]  = fields['username']
      attributes[:initials]  = fields['initials']
      attributes[:avatar_id] = fields['avatarHash']
      attributes[:bio]       = fields['bio']
      attributes[:url]       = fields['url']
      self
    end

    # Retrieve a URL to the avatar.
    #
    # Valid values for options are:
    #   :large (170x170)
    #   :small (30x30)
    def avatar_url(options = { size: :large })
      size = options[:size] == :small ? 30 : 170
      "https://trello-avatars.s3.amazonaws.com/#{avatar_id}/#{size}.png"
    end

    # Returns a list of the boards a member is a part of.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #   :filter => [ :none, :members, :organization, :public, :open, :closed, :all ] # default: :all
    # i.e.,
    #    me.boards(:filter => :closed) # retrieves all closed boards
    many :boards, filter: :all

    # Returns a list of cards the member is assigned to.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #    :filter => [ :none, :open, :closed, :all ] # default :open
    # i.e.,
    #    me.cards(:filter => :closed) # retrieves all closed cards
    many :cards, filter: :open

    # Returns a list of the organizations this member is a part of.
    #
    # This method, when called, can take a hash table with a filter key containing any
    # of the following values:
    #   :filter => [ :none, :members, :public, :all ] # default: all
    # i.e.,
    #    me.organizations(:filter => :public) # retrieves all public organizations
    many :organizations, filter: :all

    # Returns a list of notifications for the user
    many :notifications

    def save
      @previously_changed = changes
      @changed_attributes.clear

      return update! if id
    end

    def update!
      client.put(request_prefix, {
        fullName: full_name,
        bio: bio
      }).json_into(self)
    end

    # :nodoc:
    def request_prefix
      "/members/#{id}"
    end
  end
end
