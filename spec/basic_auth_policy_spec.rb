require "spec_helper"

include Trello::Authorization

describe BasicAuthPolicy do
  before do
    BasicAuthPolicy.developer_public_key = "xxx"
    BasicAuthPolicy.member_token = "xxx"
  end

  it "adds key and token query parameters" do
    BasicAuthPolicy.developer_public_key = "xxx_developer_public_key_xxx"
    BasicAuthPolicy.member_token = "xxx_member_token_xxx"

    uri = Addressable::URI.parse("https://xxx/")

    request = Request.new :get, uri

    authorized_request = BasicAuthPolicy.authorize request

    the_query_parameters = Addressable::URI.parse(authorized_request.uri).query_values

    the_query_parameters["key"].should === "xxx_developer_public_key_xxx"
    the_query_parameters["token"].should === "xxx_member_token_xxx"
  end

  it "preserves other query parameters" do
    uri = Addressable::URI.parse("https://xxx/?name=Phil")

    request = Request.new :get, uri, {:example_header => "example_value"}

    authorized_request = BasicAuthPolicy.authorize request

    the_query_parameters = Addressable::URI.parse(authorized_request.uri).query_values

    the_query_parameters["name"].should == "Phil"
  end

  it "preserves headers" do
    uri = Addressable::URI.parse("https://xxx/")

    request = Request.new :get, uri, {:example_header => "example_value"}

    authorized_request = BasicAuthPolicy.authorize request

    authorized_request.headers.should === request.headers
  end

  it "returns nil body if one is supplied" do
    uri = Addressable::URI.parse("https://xxx/")
    request = Request.new :get, uri, {}, "any body"
    BasicAuthPolicy.authorize(request).body.should be_nil
  end

  it "does what when a query parameter already exists called key or token?"
end
