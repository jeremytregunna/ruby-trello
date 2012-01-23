require "spec_helper"
require "cgi"

include Trello::Authorization
include Trello

describe OAuthPolicy do
  before do
    OAuthPolicy.consumer_credential = OAuthCredential.new "xxx", "xxx"
  end

  it "adds an authorization header" do 
    uri = Addressable::URI.parse("https://xxx/")

    request = Request.new uri

    authorized_request = OAuthPolicy.authorize request
    
    authorized_request.headers.keys.should include "Authorization"
  end
  
  it "preserves query parameters" do
    uri = Addressable::URI.parse("https://xxx/?name=Riccardo")
    request = Request.new uri

    authorized_request = OAuthPolicy.authorize request
    
    the_query_parameters = Addressable::URI.parse(authorized_request.uri).query_values
    the_query_parameters.should == {"name" => "Riccardo"}
  end

  it "adds the correct signature as part of authorization header" do 
    Clock.stub(:timestamp).and_return "1327048592"
    Nonce.stub(:next).and_return "b94ff2bf7f0a5e87a326064ae1dbb18f"

    OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"

    request = Request.new Addressable::URI.parse("http://xxx/")

    authorized_request = OAuthPolicy.authorize request
    
    authorized_request.headers["Authorization"].should =~ /oauth_signature="u7CmId4WEDUqPdHnWVf1JVChFmg%3D"/
  end

  it "adds correct signature for uri with parameters" do
    Clock.stub(:timestamp).and_return "1327351010"
    Nonce.stub(:next).and_return "f5474aaf44ca84df0b09870044f91c69"

    OAuthPolicy.consumer_credential = OAuthCredential.new "consumer_key", "consumer_secret"

    request = Request.new Addressable::URI.parse("http://xxx/?a=b")

    authorized_request = OAuthPolicy.authorize request
    
    authorized_request.headers["Authorization"].should =~ /oauth_signature="ABL%2FcOSGJSbvvLt1gW2nV9i%2FDyA%3D"/
  end

  it "adds correct signature for https uri"
  it "adds correct signature for verbs other than get"
  it "fails if consumer_credential is unset"
end
