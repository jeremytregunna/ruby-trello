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
  config.callback        = Proc.new do |request_token|
                             DB.save(request_token.key, request_token.secret)
                             redirect_to request_token.authorize_url
                           end
end
```

## Special thanks

A special thanks goes out to [Ben Biddington](https://github.com/ben-biddington) who has contributed a significant amount
of refactoring and functionality to be deserving of a beer and this special thanks.

## Contributing

Several ways you can contribute. Documentation, code, tests, feature requests, bug reports.

We develop ruby-trello using [Trello itself](https://trello.com/board/ruby-trello/4f092b2ee23cb6fe6d1aaabd).

Pick up an editor, fix a test! (If you want to, of course.) Send a pull
request, and I'll look at it. I only ask a few things:

1. Feature branches please!
2. Adding or refactoring existing features, ensure there are tests.

Also, don't be afraid to send a pull request if your changes aren't done. Just
let me know.
