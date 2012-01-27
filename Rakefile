
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => [:spec]

class Container
  class << self
    def set(parent, name, value)
      parent.send :remove_const, name
      parent.const_set name, value
    end
  end
end

require "addressable/uri"
require "trello"
include Trello
include Trello::Authorization

desc "get a new request token"
task :get_request_token do
  @developer_public_key = ENV["DEVELOPER_PUBLIC_KEY"]
  @developer_secret     = ENV["DEVELOPER_SECRET"]
  
  OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
  OAuthPolicy.token = nil

  Container.set Trello::Authorization, "AuthPolicy", OAuthPolicy
  request = Request.new :get, URI.parse("https://trello.com/1/OAuthGetRequestToken")
  request_token_response = TInternet.get AuthPolicy.authorize(request)
  
  matchdata = /oauth_token=([^&]+)&oauth_token_secret=(.+)/.match request_token_response.body	

  the_request_token = OAuthCredential.new *matchdata[1..2]

  puts "key => #{the_request_token.key}, secret => #{the_request_token.secret}"
end
