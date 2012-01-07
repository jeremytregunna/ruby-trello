# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Member
    attr_reader :fields

    class << self
      def find(id_or_username)
        response = Client.query("/1/members/#{id_or_username}")
        member = new(Yajl::Parser.parse(response.read_body))
      end
    end

    def initialize(fields = {})
      @fields = fields
    end

    # Fields of a user

    def id
      fields['id']
    end

    def full_name
      fields['fullName']
    end

    def username
      fields['username']
    end

    def gravatar_id
      fields['gravatar']
    end

    def bio
      fields['bio']
    end

    def url
      fields['url']
    end
  end
end