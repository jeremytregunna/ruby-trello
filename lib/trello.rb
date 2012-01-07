# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

require 'oauth'
require 'yajl'

module Trello
  autoload :Client, 'trello/client'
  autoload :Member, 'trello/member'
end