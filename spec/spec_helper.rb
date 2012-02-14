require 'rubygems'
unless defined? Rubinius
  require 'simplecov'
  SimpleCov.start
end

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
require 'stringio'

$strio = StringIO.new
Trello.logger = Logger.new($strio)

RSpec.configure do |c|
  c.filter_run_excluding :broken => true
end

module Helpers
  def user_details
    {
      "id"         => "abcdef123456789012345678",
      "fullName"   => "Test User",
      "username"   => "me",
      "avatarHash" => "abcdef1234567890abcdef1234567890",
      "bio"        => "a rather dumb user",
      "url"        => "https://trello.com/me"
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
      "idShort"   => "1",
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
      "date"            => "2012-02-10T11:32:17Z",
      "type"            => "createCard"
    }]
  end

  def actions_payload
    JSON.generate(actions_details)
  end

  def notification_details
    {
      "id"              => "4f30d084d5b0f7ab453bee51",
      "unread"          => false,
      "type"            => "commentCard",
      "date"            => "2012-02-07T07:19:32.393Z",
      "data"            => {
        "board"         => {
          "id"          => "abcdef123456789123456789",
          "name"        => "Test"
        },
        "card"=>{
          "id"          => "abcdef123456789123456789",
          "name"        => "Do something awesome"
        },
        "text"          => "test"
      },
      "idMemberCreator" => "abcdef123456789012345678"
    }
  end

  def notification_payload
    JSON.generate(notification_details)
  end

  def organization_details
    {
        "id" => "4ee7e59ae582acdec8000291",
        "name" => "publicorg",
        "desc" => "This is a test organization",
        "members" => [{
            "id" => "4ee7df3ce582acdec80000b2",
            "username" => "alicetester",
            "fullName" => "Alice Tester"
        }, {
            "id" => "4ee7df74e582acdec80000b6",
            "username" => "davidtester",
            "fullName" => "David Tester"
        }, {
            "id" => "4ee7e2e1e582acdec8000112",
            "username" => "edtester",
            "fullName" => "Ed Tester"
        }]
    }
  end

  def organization_payload
    JSON.generate(organization_details)
  end

  def token_details
    {
      "id"            => "4f2c10c7b3eb95a45b294cd5",
      "idMember"      => "abcdef123456789123456789",
      "dateCreated"   => "2012-02-03T16:52:23.661Z",
      "permissions"   => [
        {
          "idModel"   => "me",
          "modelType" => "Member",
          "read"      => true,
          "write"     => true
        },
        {
          "idModel"   => "*",
          "modelType" => "Board",
          "read"      => true,
          "write"     => true
        },
        {
          "idModel"   => "*",
          "modelType" => "Organization",
          "read"      => true,
          "write"     => true
        }
      ]
    }
  end

  def token_payload
    JSON.generate(token_details)
  end

  def label_details
    [
      {"color" => "yellow", "name" => "iOS"},
      {"color" => "purple", "name" => "Issue or bug"}
    ]
  end

  def label_payload
    JSON.generate(label_details)
  end
end
