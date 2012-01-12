require 'rubygems'
require 'simplecov'
SimpleCov.start

# Set up gems listed in the Gemfile.
begin
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end

Bundler.require(:spec)

require 'trello'
require 'webmock/rspec'

module Helpers
  def stub_trello_request!(http_method, path, data, returning = '')
    uri = Addressable::URI.parse("https://api.trello.com/#{Trello::API_VERSION}#{path}")
    uri.query_values = data.kind_of?(String) ? JSON.parse(data) : data if data

    stub_request(http_method, uri.to_s).
      with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
      to_return(:status => 200, :headers => {}, :body => returning)
  end

  def user_details
    {
      "id"       => "abcdef123456789012345678",
      "fullName" => "Test User",
      "username" => "me",
      "gravatar" => "abcdef1234567890abcdef1234567890",
      "bio"      => "a rather dumb user",
      "url"      => "https://trello.com/me"
    }
  end

  def user_payload
    JSON.generate(user_details)
  end

  def boards_details
    [{
      "id"             => "abcdef123456789123456789",
      "name"           => "Test",
      "desc"           => "This is a test board",
      "closed"         => false,
      "idOrganization" => "abcdef123456789123456789",
      "url"            => "https://trello.com/board/test/abcdef123456789123456789"
    }]
  end

  def boards_payload
    JSON.generate(boards_details)
  end

  def checklists_details
    [{
      "id"         => "abcdef123456789123456789",
      "name"       => "Test Checklist",
      "desc"       => "A marvelous little checklist",
      "closed"     => false,
      "url"        => "https://trello.com/blah/blah",
      "idBoard"    => "abcdef123456789123456789",
      "idMembers"  => ["abcdef123456789123456789"],
      "checkItems" => {}
    }]
  end

  def checklists_payload
    JSON.generate(checklists_details)
  end

  def lists_details
    [{
      "id"      => "abcdef123456789123456789",
      "name"    => "To Do",
      "closed"  => false,
      "idBoard" => "abcdef123456789123456789",
      "cards"   => cards_details
    }]
  end

  def lists_payload
    JSON.generate(lists_details)
  end

  def cards_details
    [{
      "id"        => "abcdef123456789123456789",
      "name"      => "Do something awesome",
      "desc"      => "Awesome things are awesome.",
      "closed"    => false,
      "idList"    => "abcdef123456789123456789",
      "idBoard"   => "abcdef123456789123456789",
      "idMembers" => ["abcdef123456789123456789"],
      "url"       => "https://trello.com/card/board/specify-the-type-and-scope-of-the-jit-in-a-lightweight-spec/abcdef123456789123456789/abcdef123456789123456789"
    }]
  end

  def cards_payload
    JSON.generate(cards_details)
  end

  def orgs_details
    [{
      "id"          => "abcdef123456789123456789",
      "name"        => "test",
      "displayName" => "Test Organization",
      "desc"        => "This is a test organization",
      "url"         => "https://trello.com/test"
    }]
  end

  def orgs_payload
    JSON.generate(orgs_details)
  end

  def actions_details
    [{
      "id"              => "4ee2482134a81a757a08af47",
      "idMemberCreator" => "abcdef123456789123456789",
      "data"=> {
        "card"          => {
          "id"          => "4ee2482134a81a757a08af45",
          "name"        => "Bytecode outputter"
        },
        "board"         => {
          "id"          => "4ec54f2f73820a0dea0d1f0e",
          "name"        => "Caribou VM"
        },
        "list"          => {
          "id"          => "4ee238b034a81a757a05cda0",
          "name"        => "Assembler"
        }
      },
      "type"            => "createCard"
    }]
  end

  def actions_payload
    JSON.generate(actions_details)
  end
end