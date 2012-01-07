require 'rubygems'

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
  def user_details
    {
      "id"       => "abcdef123456789012345678",
      "fullName" => "Test User",
      "username" => "me",
      "gravatar" => "abcdef1234567890abcdef1234567890",
      "bio"      => "a rather dumb user",
      "url"      => "https://trello.com/jer"
    }
  end

  def user_payload
    Yajl::Encoder.encode(user_details)
  end

  def stub_oauth!
    stub_request(:get, "https://api.trello.com/1/members/me?").
       with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
       to_return(:status => 200, :headers => {}, :body => user_payload)
  end
end