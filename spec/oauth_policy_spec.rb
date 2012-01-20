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

  it "preserves query parameters"
end
