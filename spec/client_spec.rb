require "spec_helper"

include Trello

describe Client, "and how it handles authorization" do
  before do
    fake_response = stub "A fake OK response"
    fake_response.stub(:code).and_return 200
    TInternet.stub(:get).and_return fake_response
    AuthPolicy.stub(:authorize) do |request|
      request
    end
  end
  
  it "authorizes before it queries the internet" do 
    AuthPolicy.should_receive(:authorize).once.ordered
    TInternet.should_receive(:get).once.ordered
    
    Client.get 1, "/xxx"
  end

  it "queries the internet with expanded earl and query parameters" do
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?a=1&b=2")
    expected_request = Request.new expected_uri, {}

    TInternet.should_receive(:get).once.with expected_request
    
    Client.get 1, "/xxx", :a => "1", :b => "2"
  end

  it "encodes parameters" do 
    expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?name=Jazz%20Kang")
    expected_request = Request.new expected_uri, {}
    
    TInternet.should_receive(:get).once.with expected_request
    
    Client.get 1, "/xxx", :name => "Jazz Kang"
  end

  it "raises an error when response has non-200 status" do
    response_with_non_200_status = stub "A fake OK response"
    response_with_non_200_status.stub(:code).and_return 201

    TInternet.stub(:get).and_return response_with_non_200_status

    lambda{Client.get 1, "/xxx"}.should raise_error
  end

  it "you don't need to supply api version"
end
