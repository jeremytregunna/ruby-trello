require "spec_helper"

include Trello::Authorization
include Trello

describe OAuthPolicy do
  before do
    OAuthPolicy.consumer_credential = OAuthCredential.new "xxx", "xxx"
    OAuthPolicy.token = nil
  end

  context "2-legged" do
    it "adds an authorization header" do 
      uri = Addressable::URI.parse("https://xxx/")

      request = Request.new :get, uri

      OAuthPolicy.token               = OAuthCredential.new "token", nil

      authorized_request = OAuthPolicy.authorize request
      
      authorized_request.headers.keys.should include "Authorization"
    end
    
    it "preserves query parameters" do
      uri = Addressable::URI.parse("https://xxx/?name=Riccardo")
      request = Request.new :get, uri

      Clock.stub(:timestamp).and_return "1327048592"
      Nonce.stub(:next).and_return "b94ff2bf7f0a5e87a326064ae1dbb18f"
      OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"
      OAuthPolicy.token               = OAuthCredential.new "token", nil

      authorized_request = OAuthPolicy.authorize request
      
      the_query_parameters = Addressable::URI.parse(authorized_request.uri).query_values
      the_query_parameters.should == {"name" => "Riccardo"}
    end

    it "adds the correct signature as part of authorization header" do 
      Clock.stub(:timestamp).and_return "1327048592"
      Nonce.stub(:next).and_return "b94ff2bf7f0a5e87a326064ae1dbb18f"

      OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"
      OAuthPolicy.token               = OAuthCredential.new "token", nil

      request = Request.new :get, Addressable::URI.parse("http://xxx/")

      authorized_request = OAuthPolicy.authorize request
      
      authorized_request.headers["Authorization"].should =~ /oauth_signature="kLcSxrCTd4ATHcLmTp8q%2Foa%2BFMA%3D"/
    end

    it "adds correct signature for uri with parameters" do
      Clock.stub(:timestamp).and_return "1327351010"
      Nonce.stub(:next).and_return "f5474aaf44ca84df0b09870044f91c69"

      OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"
      OAuthPolicy.token               = OAuthCredential.new "token", nil

      request = Request.new :get, Addressable::URI.parse("http://xxx/?a=b")

      authorized_request = OAuthPolicy.authorize request
      
      authorized_request.headers["Authorization"].should =~ /oauth_signature="xm%2FJ1swxxPb6mnuR1Q1ucJMdGRk%3D"/
    end

    it "fails if consumer_credential is unset" do
      OAuthPolicy.consumer_credential = nil

      request = Request.new :get, Addressable::URI.parse("http://xxx/")

      lambda{OAuthPolicy.authorize request}.should raise_error "The consumer_credential has not been supplied."
    end

    it "can sign with token" do
      Clock.stub(:timestamp).and_return "1327360530"
      Nonce.stub(:next).and_return "4f610cb28e7aa8711558de5234af1f0e"

      OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"
      OAuthPolicy.token  = OAuthCredential.new "token_key", "token_secret"

      request = Request.new :get, Addressable::URI.parse("http://xxx/")

      authorized_request = OAuthPolicy.authorize request

      authorized_request.headers["Authorization"].should =~ /oauth_signature="3JeZSzsLCYnGNdVALZMgbzQKN44%3D"/
    end

    it "adds correct signature for https uri"
    it "adds correct signature for verbs other than get"
  end
end
