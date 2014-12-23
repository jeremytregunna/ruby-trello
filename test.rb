$LOAD_PATH.unshift 'lib'
require 'trello'

include Trello
include Trello::Authorization

Trello::Authorization.const_set :AuthPolicy, OAuthPolicy

# First arg is your public key, and second is secret.
# You can get this info by going to:
# https://trello.com/1/appKey/generate
OAuthPolicy.consumer_credential = OAuthCredential.new 'PUBLIC_KEY', 'SECRET'
# First arg is the access token key, second is presently not used -- trello bug?
# You can get the key by going to this url in your browser:
# https://trello.com/1/authorize?key=PUBLIC_KEY_FROM_ABOVE&name=MyApp&response_type=token&scope=read,write,account&expiration=never
# Only request the permissions you need; i.e., scope=read if you only need read, or scope=write if you only need write. Comma separate scopes you need.
# If you want your token to expire after 30 days, drop the &expiration=never.
OAuthPolicy.token = OAuthCredential.new 'ACCESS_TOKEN_KEY', nil

me = Member.find("me")
board = Board.create(name: "ruby-trello test")
if board.has_lists?
  list = board.lists.first
else
  list = List.create(name: "Getting Shit done", board_id: board.id)
end
Card.create(name: "test from ruby-trello", description: "Just a desc", list_id: list.id)
