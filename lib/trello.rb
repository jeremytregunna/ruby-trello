# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

require 'oauth'
require 'json'

module Trello
  autoload :BasicData,    'trello/basic_data'
  autoload :Board,        'trello/board'
  autoload :Card,         'trello/card'
  autoload :Client,       'trello/client'
  autoload :List,         'trello/list'
  autoload :Member,       'trello/member'
  autoload :Organization, 'trello/organization'
end