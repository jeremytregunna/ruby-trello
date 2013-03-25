require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => [:spec]

namespace :example do
  $LOAD_PATH.unshift 'lib'
  require "addressable/uri"
  require "trello"
  include Trello
  include Trello::Authorization

  desc "get a new request token"
  task :get_request_token do
    ensure_consumer_credentials

    @developer_public_key = ENV["DEVELOPER_PUBLIC_KEY"]
    @developer_secret     = ENV["DEVELOPER_SECRET"]

    OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
    OAuthPolicy.token = nil

    request = Request.new :get, URI.parse("https://trello.com/1/OAuthGetRequestToken")
    response = TInternet.execute OAuthPolicy.authorize(request)

    the_request_token = parse_token(response.body)

    puts "key => #{the_request_token.key}, secret => #{the_request_token.secret}"
  end

  desc "convert request token to access token"
  task :get_access_token, :request_token_key, :request_token_secret, :oauth_verifier do |t, args|
    ensure_consumer_credentials
    @developer_public_key = ENV["DEVELOPER_PUBLIC_KEY"]
    @developer_secret     = ENV["DEVELOPER_SECRET"]

    OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
    OAuthPolicy.token = OAuthCredential.new args.request_token_key, args.request_token_secret

    access_token_request = Request.new :get, URI.parse("https://trello.com/1/OAuthGetAccessToken?oauth_verifier=#{args.oauth_verifier}")
    response = TInternet.execute OAuthPolicy.authorize(access_token_request)

    the_access_token = parse_token response.body

    puts "key => #{the_access_token.key}, secret => #{the_access_token.secret}"
  end

    def ensure_consumer_credentials
      %w{PUBLIC_KEY SECRET}.each do |name|
        fullname = "DEVELOPER_#{name}"
        unless ENV[fullname]
          puts "ERROR: Missing <#{fullname}> environment variable."
	  exit 1
        end
      end
  end

  def parse_token(text)
    matchdata = /oauth_token=([^&]+)&oauth_token_secret=(.+)/.match text

    the_request_token = OAuthCredential.new *matchdata[1..2]
  end
end
