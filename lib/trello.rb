require 'oauth'
require 'json'
require 'logger'
require 'active_model'

# Ruby wrapper around the Trello[http://trello.com] API
#
# First, set up your key information. You can get this information by {clicking here}[https://trello.com/1/appKey/generate].
#
#   Trello.public_key = 'xxxxxxxxxxxxxxxxx'
#   Trello.secret     = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
#
# All the calls this library make to Trello require authentication using these keys. Be sure to protect them.
#
# So lets say you want to get information about the user *bobtester*. We can do something like this:
#
#   bob = Member.find("bobtester")
#   # Print out his name
#   puts bob.full_name # "Bob Tester"
#   # Print his bio
#   puts bob.bio # A wonderfully delightful test user
#   # How about a list of his boards?
#   bob.boards
#
# And so much more. Consult the rest of the documentation for more information.
#
# Feel free to {peruse and participate in our Trello board}[https://trello.com/board/ruby-trello/4f092b2ee23cb6fe6d1aaabd]. It's completely open to the public.
module Trello
  autoload :Action,            'trello/action'
  autoload :Association,       'trello/association'
  autoload :AssociationProxy,  'trello/association_proxy'
  autoload :BasicData,         'trello/basic_data'
  autoload :Board,             'trello/board'
  autoload :Card,              'trello/card'
  autoload :Checklist,         'trello/checklist'
  autoload :Client,            'trello/client'
  autoload :HasActions,        'trello/has_actions'
  autoload :Item,              'trello/item'
  autoload :ItemState,         'trello/item_state'
  autoload :Label,             'trello/label'
  autoload :List,              'trello/list'
  autoload :Member,            'trello/member'
  autoload :MultiAssociation,  'trello/multi_association'
  autoload :Notification,      'trello/notification'
  autoload :Organization,      'trello/organization'
  autoload :Request,           'trello/net'
  autoload :TInternet,         'trello/net'
  autoload :Token,             'trello/token'

  module Authorization
    autoload :AuthPolicy,      'trello/authorization'
    autoload :BasicAuthPolicy, 'trello/authorization'
    autoload :OAuthPolicy,     'trello/authorization'
  end

  # Version of the Trello API that we use by default.
  API_VERSION = 1

  # Raise this when we hit a Trello error.
  class Error < StandardError; end
  # This specific error is thrown when your access token is invalid. You should get a new one.
  class InvalidAccessToken < StandardError; end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
