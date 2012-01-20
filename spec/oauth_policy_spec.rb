require "spec_helper"

include Trello

class OAuthPolicy
  class << self
    def authorize(request)
      request.headers = {"Authorization" => nil}
      request
    end
  end
end

describe OAuthPolicy do
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
end
