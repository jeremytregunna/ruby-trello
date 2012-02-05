$LOAD_PATH.unshift 'lib'
require 'trello'

include Trello
include Trello::Authorization

Trello::Authorization.const_set :AuthPolicy, OAuthPolicy

# First arg is your public key, and second is secret.
# You can get this info by going to:
# https://trello.com/1/appKey/generate
OAuthPolicy.consumer_credential = OAuthCredential.new 'a6ae0b8e99f9e968dfceaee32a992da9', '0d8dc80d3b9c1af8be06a4c3dfee694a594d0b5f10592c1310a7d6ab6b5c647b'
# First arg is the access token key, second is presently not used -- trello bug?
# You can get the key by going to this url in your browser:
# https://trello.com/1/connect?key=PUBLIC_KEY_FROM_ABOVE&name=MyApp&response_type=token&scope=read,write,account&expiration=never
# Only request the permissions you need; i.e., scope=read if you only need read, or scope=write if you only need write. Comma separate scopes you need.
# If you want your token to expire after 30 days, drop the &expiration=never.
OAuthPolicy.token = OAuthCredential.new '106b8a3f4a235c985911f1198f7514ab03aace02eed8b070bde62b53727b0f8b', nil

me = Member.find("me")
board = Board.find("4f2d8e63470ccecd592d0354")
card = Card.find("4f2d8e66a17524053d6fee9a")
p card.remove_label("red")
#checklist = Checklist.find("4f2db6a5746b593a3f778b5f")
# card.add_checklist(checklist)
# checklist = Checklist.create(:name => "awesome checklist", :board_id => board.id)
#checklist.add_item("make sure this works")
#p checklist
