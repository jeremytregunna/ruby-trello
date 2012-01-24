require "spec_helper"

include Trello
include Trello::Authorization

describe Client, "and how it handles authorization" do
  before do
    fake_response = stub "A fake OK response"
    fake_response.stub(:code).and_return 200
    fake_response.stub(:body).and_return "A fake response body"

    TInternet.stub(:get).and_return fake_response
    Authorization::AuthPolicy.stub(:authorize) do |request|
      request
    end
  end

  it "authorizes before it queries the internet" do
    AuthPolicy.should_receive(:authorize).once.ordered
    TInternet.should_receive(:get).once.ordered

    Client.get "/xxx"
  end

  it "queries the internet with expanded earl and query parameters" do
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?a=1&b=2")
    expected_request = Request.new :get, expected_uri, {}

    TInternet.should_receive(:get).once.with expected_request

    Client.get "/xxx", :a => "1", :b => "2"
  end

  it "encodes parameters" do
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?name=Jazz%20Kang")
    expected_request = Request.new :get, expected_uri, {}

    TInternet.should_receive(:get).once.with expected_request

    Client.get "/xxx", :name => "Jazz Kang"
  end

  it "raises an error when response has non-200 status" do
    response_with_non_200_status = stub "A fake OK response"
    response_with_non_200_status.stub(:code).and_return 201

    TInternet.stub(:get).and_return response_with_non_200_status

    lambda{Client.get "/xxx"}.should raise_error
  end
end
