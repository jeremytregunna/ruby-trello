require "spec_helper"

include Trello
include Trello::Authorization

describe Client, "and how it handles authorization" do
  let (:fake_ok_response) {
    double "A fake OK response",
      :code => 200,
      :body => "A fake response body"
  }
  let(:client) { Client.new }
  let(:auth_policy) { double }

  before do
    TInternet.stub(:execute).and_return fake_ok_response
    Authorization::AuthPolicy.stub(:new).and_return(auth_policy)
    auth_policy.stub(:authorize) do |request|
      request
    end
  end

  it "authorizes before it queries the internet" do
    auth_policy.should_receive(:authorize).once.ordered
    TInternet.should_receive(:execute).once.ordered

    client.get "/xxx"
  end

  it "queries the internet with expanded earl and query parameters" do
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?a=1&b=2")
    expected_request = Request.new :get, expected_uri, {}

    TInternet.should_receive(:execute).once.with expected_request

    client.get "/xxx", :a => "1", :b => "2"
  end

  it "encodes parameters" do
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?name=Jazz%20Kang")
    expected_request = Request.new :get, expected_uri, {}

    TInternet.should_receive(:execute).once.with expected_request

    client.get "/xxx", :name => "Jazz Kang"
  end

  it "raises an error when response has non-200 status" do
    expected_error_message = "An error response"
    response_with_non_200_status = double "A fake OK response",
      :code => 404,
      :body => expected_error_message

    TInternet.stub(:execute).and_return response_with_non_200_status

    -> { client.get "/xxx" }.should raise_error expected_error_message
  end

  it "uses version 1 of the API" do
    TInternet.should_receive(:execute).once do |request|
      request.uri.to_s.should =~ /1\//
      fake_ok_response
    end

    client.get "/"
  end

  it "omits the \"?\" when no parameters" do
    TInternet.should_receive(:execute).once do |request|
      request.uri.to_s.should_not =~ /\?$/
      fake_ok_response
    end

    client.get "/xxx"
  end

  it "supports post" do
    TInternet.should_receive(:execute).once.and_return fake_ok_response

    client.post "/xxx", { :phil => "T' north" }
  end

  it "supplies the body for a post" do
    expected_body = { :name => "Phil", :nickname => "The Crack Fox" }

    TInternet.should_receive(:execute).once do |request|
      request.body.should == expected_body
      fake_ok_response
    end

    client.post "/xxx", expected_body
  end

  it "supplies the path for a post" do
    expected_path = "/xxx"

    TInternet.should_receive(:execute).once do |request|
      request.uri.path.should =~ /#{expected_path}$/
      fake_ok_response
    end

    client.post "/xxx", {}
  end

  it "supports put" do
    expected_path = "/xxx"

    TInternet.should_receive(:execute).once.and_return fake_ok_response

    client.put "/xxx", { :phil => "T' north" }
  end

  it "supplies the body for a put" do
    expected_body = { :name => "Phil", :nickname => "The Crack Fox" }

    TInternet.should_receive(:execute).once do |request|
      request.body.should == expected_body
      fake_ok_response
    end

    client.put "/xxx", expected_body
  end

  it "supplies the path for a put" do
    expected_path = "/xxx"

    TInternet.should_receive(:execute).once do |request|
      request.uri.path.should =~ /#{expected_path}$/
      fake_ok_response
    end

    client.put "/xxx", {}
  end

  context "initialize" do
    let(:client) {
      Client.new(
        :consumer_key => 'consumer_key',
        :consumer_secret => 'consumer_secret',
        :oauth_token => 'oauth_token',
        :oauth_token_secret => 'oauth_token_secret'
      )
    }

    it "is configurable" do
      client.consumer_key.should eq('consumer_key')
      client.consumer_secret.should eq('consumer_secret')
      client.oauth_token.should eq('oauth_token')
      client.oauth_token_secret.should eq('oauth_token_secret')
    end
  end

  describe "configure" do
    it "sets key attributes through config block" do
      client.configure do |config|
        config.consumer_key = 'consumer_key'
        config.consumer_secret = 'consumer_secret'
        config.oauth_token = 'oauth_token'
        config.oauth_token_secret = 'oauth_token_secret'
      end

      client.consumer_key.should eq('consumer_key')
      client.consumer_secret.should eq('consumer_secret')
      client.oauth_token.should eq('oauth_token')
      client.oauth_token_secret.should eq('oauth_token_secret')
    end
  end
end
