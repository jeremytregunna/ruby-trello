[![Stories in Ready](http://badge.waffle.io/jeremytregunna/ruby-trello.png)](http://waffle.io/jeremytregunna/ruby-trello)  
# Ruby Trello API

[![Build Status](https://secure.travis-ci.org/jeremytregunna/ruby-trello.png)](http://travis-ci.org/jeremytregunna/ruby-trello) [![Dependency Status](https://gemnasium.com/jeremytregunna/ruby-trello.png)](https://gemnasium.com/jeremytregunna/ruby-trello.png)

This library implements the [Trello](http://www.trello.com/) [API](http://trello.com/api).

Trello is an awesome tool for organization. Not just aimed at developers, but everybody.
Seriously, [check it out](http://www.trello.com/).

## Installation

```
# gem install ruby-trello
```

Full Disclosure: This library is mostly complete, if you do find anything missing or not functioning as you expect it
to, please [let us know](https://trello.com/card/spot-a-bug-report-it/4f092b2ee23cb6fe6d1aaabd/17).

## Configuration

Basic authorization

```ruby
Trello.configure do |config|
  config.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY
  config.member_token = TRELLO_MEMBER_TOKEN
end
```

2-legged OAuth authorization

```ruby
Trello.configure do |config|
  config.consumer_key = TRELLO_CONSUMER_KEY
  config.consumer_secret = TRELLO_CONSUMER_SECRET
  config.oauth_token = TRELLO_OAUTH_TOKEN
  config.oauth_token_secret = TRELLO_OAUTH_TOKEN_SECRET
end
```

3-legged OAuth authorization

```ruby
Trello.configure do |config|
  config.consumer_key    = TRELLO_CONSUMER_KEY
  config.consumer_secret = TRELLO_CONSUMER_SECRET
  config.return_url      = "http://your.site.com/path/to/receive/post"
  config.callback        = lambda { |request_token| DB.save(request_token.key, request_token.secret) }
end
```

All the calls this library make to Trello require authentication using these keys. Be sure to protect them.

So lets say you want to get information about the user *bobtester*. We can do something like this:

```ruby
bob = Trello::Member.find("bobtester")
# Print out his name
puts bob.full_name # "Bob Tester"
# Print his bio
puts bob.bio # A wonderfully delightful test user
# How about a list of his boards?
bob.boards
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

We develop ruby-trello using [Trello itself](https://trello.com/board/ruby-trello/4f092b2ee23cb6fe6d1aaabd).

Please see the `CONTRIBUTING.md` file for more information.
