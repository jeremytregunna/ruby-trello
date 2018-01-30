# Ruby Trello API

[![Stories in Ready](http://badge.waffle.io/jeremytregunna/ruby-trello.png)](http://waffle.io/jeremytregunna/ruby-trello)
[![Build Status](https://secure.travis-ci.org/jeremytregunna/ruby-trello.png)](http://travis-ci.org/jeremytregunna/ruby-trello) [![Dependency Status](https://gemnasium.com/jeremytregunna/ruby-trello.png)](https://gemnasium.com/jeremytregunna/ruby-trello)
[![Code Climate](https://codeclimate.com/github/jeremytregunna/ruby-trello/badges/gpa.svg)](https://codeclimate.com/github/jeremytregunna/ruby-trello)

This library implements the [Trello](http://www.trello.com/) [API](https://developers.trello.com/).

Trello is an awesome tool for organization. Not just aimed at developers, but everybody.
Seriously, [check it out](http://www.trello.com/).

[Full API documentation](http://www.rubydoc.info/gems/ruby-trello).

## Installation

```
# gem install ruby-trello
```

Full Disclosure: This library is mostly complete, if you do find anything missing or not functioning as you expect it
to, please [let us know](https://trello.com/card/spot-a-bug-report-it/4f092b2ee23cb6fe6d1aaabd/17).

Supports Ruby 2.1.0 or newer.

Use version 1.3.0 or earlier for Ruby 1.9.3 support.
Use version 1.4.x or earlier for Ruby 2.0.0 support.

## Configuration

#### Basic authorization:

1. Get your API public key from Trello via the irb console:

```
$ gem install ruby-trello
$ irb -rubygems
irb> require 'trello'
irb> Trello.open_public_key_url                         # copy your public key
irb> Trello.open_authorization_url key: 'yourpublickey' # copy your member token
```

2. You can now use the public key and member token in your app code:

```ruby
require 'trello'

Trello.configure do |config|
  config.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY # The "key" from step 1
  config.member_token = TRELLO_MEMBER_TOKEN # The token from step 2.
end
```

#### 2-legged OAuth authorization

```ruby
Trello.configure do |config|
  config.consumer_key = TRELLO_CONSUMER_KEY
  config.consumer_secret = TRELLO_CONSUMER_SECRET
  config.oauth_token = TRELLO_OAUTH_TOKEN
  config.oauth_token_secret = TRELLO_OAUTH_TOKEN_SECRET
end
```

#### 3-legged OAuth authorization

```ruby
Trello.configure do |config|
  config.consumer_key    = TRELLO_CONSUMER_KEY
  config.consumer_secret = TRELLO_CONSUMER_SECRET
  config.return_url      = "http://your.site.com/path/to/receive/post"
  config.callback        = lambda { |request_token| DB.save(request_token.key, request_token.secret) }
end
```

All the calls this library makes to Trello require authentication using these keys. Be sure to protect them.

#### Usage

So let's say you want to get information about the user *bobtester*. We can do something like this:

```ruby
bob = Trello::Member.find("bobtester")

# Print out his name
puts bob.full_name # "Bob Tester"

# Print his bio
puts bob.bio # A wonderfully delightful test user

# How about a list of his boards?
bob.boards

# And then to read the lists of the first board do : 
bob.boards.first.lists
```

##### Accessing specific items

There is no find by name method in the trello API, to access a specific item, you have to know it's ID.
The best way is to pretty print the elements and then find the id of the element you are looking for.

```ruby
# With bob
pp bob.boards # Will pretty print all boards, allowing us to find our board id

# We can now access it's lists
pp Trello::Board.find( board_id ).lists # will pretty print all lists. Let's get the list id

# We can now access the cards of the list
pp Trello::List.find( list_id ).cards

# We can now access the checklists of the card
pp Trello::Card.find( card_id ).checklists

# and so on ...
```

##### Changing a checkbox state
```ruby
# First get your checklist id 
checklist = Trello::Checklist.find( checklist_id )

# At this point, there is no more ids. To get your checklist item, 
# you have to know it's position (same as in the trello interface).
# Let's take the first
checklist_item = checklist.items.first

# Then we can read the status
checklist_item.state # return 'complete' or 'incomplete'

# We can update it (note we call update_item_state from checklist, not from checklist_item)
checklist.update_item_state( checklist_item.id, 'complete' ) # or 'incomplete'

# You can also use true or false instead of 'complete' or 'incomplete'
checklist.update_item_state( checklist_item.id, true ) # or false
```

#### Multiple Users

Applications that make requests on behalf of multiple Trello users have an alternative to global configuration. For each user's access token/secret pair, instantiate a `Trello::Client`:

```ruby
@client_bob = Trello::Client.new(
  :consumer_key => YOUR_CONSUMER_KEY,
  :consumer_secret => YOUR_CONSUMER_SECRET,
  :oauth_token => "Bob's access token",
  :oauth_token_secret => "Bob's access secret"
)

@client_alice = Trello::Client.new(
  :consumer_key => YOUR_CONSUMER_KEY,
  :consumer_secret => YOUR_CONSUMER_SECRET,
  :oauth_token => "Alice's access token",
  :oauth_token_secret => "Alice's access secret"
)
```

You can now make threadsafe requests as the authenticated user:

```ruby
Thread.new do
  @client_bob.find(:members, "bobtester")
  @client_bob.find(:boards, "bobs_board_id")
end
Thread.new do
  @client_alice.find(:members, "alicetester")
  @client_alice.find(:boards, "alices_board_id")
end
```

## Special thanks

A special thanks goes out to [Ben Biddington](https://github.com/ben-biddington) who has contributed a significant amount
of refactoring and functionality to be deserving of a beer and this special thanks.

## Contributing

Several ways you can contribute. Documentation, code, tests, feature requests, bug reports.

If you submit a pull request that's accepted, you'll be given commit access to this repository.

Please see the `CONTRIBUTING.md` file for more information.
