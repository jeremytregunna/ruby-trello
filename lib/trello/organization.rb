# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

class Trello::Organization
  class << self
    def find(id)
      response = Client.query("/1/organizations/#{id}")
      new(Yajl::Parser.parse(response.read_body))
    end
  end

  def initialize(fields = {})
    @fields = fields
  end

  # Fields

  def id
    @fields['id']
  end

  def name
    @fields['name']
  end

  def display_name
    @fields['display_name']
  end

  def description
    @fields['desc']
  end

  def url
    @fields['url']
  end
end