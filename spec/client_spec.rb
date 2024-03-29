require "spec_helper"
require "rest-client"
require "faraday"

include Trello
include Trello::Authorization

describe Client do

  let(:client) { Client.new }
  let(:auth_policy) { double }

  before do
    allow(Authorization::AuthPolicy)
      .to receive(:new)
           .and_return(auth_policy)

    allow(auth_policy)
      .to receive(:authorize) { |request| request }
  end

  describe "and how it handles RestClient exceptions" do

    before do
      Trello.http_client = 'rest-client'
    end

    context "with RestClient::Exception sans HTTP code" do
      let(:rc_exception_without_http_code) { RestClient::Exception.new }

      before do
        allow(Trello::TRestClient::TInternet)
          .to receive(:execute_core)
          .and_raise(rc_exception_without_http_code)
      end

      it "bubbles up RestClient::Exception errors that don't contain an HTTP code" do
        expect { client.get "/xxx" }.to raise_error rc_exception_without_http_code
      end
    end

    context "with RestClient::Exception that contains HTTP code" do
      let(:response_with_non_200_status) { double "A fake 404 response",
                                              code: 404,
                                              body: "404 error response"}
      let(:rc_exception_with_http_code) { RestClient::Exception.new(double("404 error response", {:code => 404, :body => "404 error response"}))}

      before do
        allow(Trello::TRestClient::TInternet)
          .to receive(:execute_core)
          .and_raise(rc_exception_with_http_code)
      end

      it "raises Error" do

        expect(Trello::TRestClient::TInternet)
          .to receive(:try_execute)
          .and_return(response_with_non_200_status)

        expect { client.get "/xxx" }.to raise_error do |error|
          expect(error).to be_a(Error)
          expect(error.message).to eq("404 error response")
          expect(error.status_code).to eq(404)
        end
      end
    end
  end

  describe "and how it handles Faraday errors" do

    before do
      Trello.http_client = 'faraday'
    end

    context "with Faraday::Error sans HTTP code" do
      let(:faraday_error_without_http_code) { Faraday::Error.new("Test error") }

      before do
        allow(Trello::TFaraday::TInternet)
          .to receive(:execute_core)
          .and_raise(faraday_error_without_http_code)
      end

      it "bubbles up Faraday::Error errors that don't contain an HTTP code" do
        expect { client.get "/xxx" }.to raise_error faraday_error_without_http_code
      end
    end

    context "with Faraday::Error that contains HTTP code" do
      let(:response_with_non_200_status) { double "A fake 404 response",
                                              code: 404,
                                              body: "404 error response"}
      let(:faraday_error_with_http_code) { Faraday::Error.new(double("404 error response", {:code => 404, :body => "404 error response"}))}

      before do
        allow(Trello::TFaraday::TInternet)
          .to receive(:execute_core)
          .and_raise(faraday_error_with_http_code)
      end

      it "raises Error" do

        expect(Trello::TFaraday::TInternet)
          .to receive(:try_execute)
          .and_return(response_with_non_200_status)

        expect { client.get "/xxx" }.to raise_error do |error|
          expect(error).to be_a(Error)
          expect(error.message).to eq("404 error response")
          expect(error.status_code).to eq(404)
        end
      end
    end
  end

  describe "and how it handles authorization" do
    let (:fake_ok_response) do
      double "A fake OK response",
             code: 200,
             body: "A fake response body"
    end
    let(:client) { Client.new }
    let(:auth_policy) { double }

    before do
      allow(TInternet)
        .to receive(:execute)
             .and_return fake_ok_response

      allow(Authorization::AuthPolicy)
        .to receive(:new)
             .and_return(auth_policy)

      allow(auth_policy)
        .to receive(:authorize) { |request| request }
    end

    it "authorizes before it queries the internet" do
      expect(auth_policy)
        .to receive(:authorize)
             .once
             .ordered

      expect(TInternet)
        .to receive(:execute)
             .once
             .ordered

      client.get "/xxx"
    end

    it "queries the internet with expanded earl and query parameters" do
      expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?a=1&b=2")
      expected_request = Request.new :get, expected_uri, {}

      expect(TInternet)
        .to receive(:execute)
             .once
             .with expected_request

      client.get "/xxx", a: "1", b: "2"
    end

    it "encodes parameters" do
      expected_uri = Addressable::URI.parse("https://api.trello.com/1/xxx?name=Jazz%20Kang")
      expected_request = Request.new :get, expected_uri, {}

      expect(TInternet)
        .to receive(:execute)
             .once
             .with expected_request

      client.get "/xxx", name: "Jazz Kang"
    end

    it "raises an error when response has non-200 status" do
      expected_error_message = "An error response"
      response_with_non_200_status = double "A fake OK response",
                                            code: 404,
                                            body: expected_error_message

      expect(TInternet)
        .to receive(:execute)
             .and_return response_with_non_200_status

      expect { client.get "/xxx" }.to raise_error expected_error_message
    end

    it "uses version 1 of the API" do
      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.uri.to_s).to match(/1\//)
        fake_ok_response
      end

      client.get "/"
    end

    it "omits the \"?\" when no parameters" do
      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.uri.to_s).not_to match(/\?$/)
        fake_ok_response
      end

      client.get "/xxx"
    end

    it "supports post" do
      expect(TInternet)
        .to receive(:execute)
             .once
             .and_return fake_ok_response

      client.post "/xxx", { phil: "T' north" }
    end

    it "supplies the body for a post" do
      expected_body = { name: "Phil", nickname: "The Crack Fox" }

      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.body).to eq expected_body
        fake_ok_response
      end

      client.post "/xxx", expected_body
    end

    it "supplies the path for a post" do
      expected_path = "/xxx"

      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.uri.path).to match(/#{expected_path}$/)
        fake_ok_response
      end

      client.post "/xxx", {}
    end

    it "supports put" do
      expect(TInternet)
        .to receive(:execute)
             .once
             .and_return fake_ok_response

      client.put "/xxx", { phil: "T' north" }
    end

    it "supplies the body for a put" do
      expected_body = { name: "Phil", nickname: "The Crack Fox" }

      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.body).to eq expected_body
        fake_ok_response
      end

      client.put "/xxx", expected_body
    end

    it "supplies the path for a put" do
      expected_path = "/xxx"

      expect(TInternet)
        .to receive(:execute)
             .once do |request|
        expect(request.uri.path).to match(/#{expected_path}$/)
        fake_ok_response
      end

      client.put "/xxx", {}
    end

    context "initialize" do
      let(:client) do
        Client.new(
          consumer_key: 'consumer_key',
          consumer_secret: 'consumer_secret',
          oauth_token: 'oauth_token',
          oauth_token_secret: 'oauth_token_secret'
        )
      end

      it "is configurable" do
        expect(client.consumer_key).to eq('consumer_key')
        expect(client.consumer_secret).to eq('consumer_secret')
        expect(client.oauth_token).to eq('oauth_token')
        expect(client.oauth_token_secret).to eq('oauth_token_secret')
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

        expect(client.consumer_key).to eq('consumer_key')
        expect(client.consumer_secret).to eq('consumer_secret')
        expect(client.oauth_token).to eq('oauth_token')
        expect(client.oauth_token_secret).to eq('oauth_token_secret')
      end
    end
  end
end
