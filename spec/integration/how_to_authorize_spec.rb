require 'spec_helper'
require 'integration/integration_test'

describe "Authorizing read-only requests", broken: true do
  include IntegrationTest

  it "Reading public resources requires just a developer public key" do
    uri = Addressable::URI.parse("https://api.trello.com/1/boards/4ed7e27fe6abb2517a21383d")
    uri.query_values = {
      key: @developer_public_key
    }

    get(uri).code.should === 200
  end

  it "Reading private resources requires developer public key AND a member token" do
    uri = Addressable::URI.parse("https://api.trello.com/1/boards/#{@welcome_board}")
    uri.query_values = {
      key: @developer_public_key,
      token: @member_token
    }

    get(uri).code.should === 200
  end

  it "can fetch the welcome board" do
    BasicAuthPolicy.developer_public_key = @developer_public_key
    BasicAuthPolicy.member_token = @member_token

    Container.set Trello::Authorization, "AuthPolicy", BasicAuthPolicy

    welcome_board = Board.find @welcome_board
    welcome_board.name.should === "Welcome Board"
    welcome_board.id.should === @welcome_board
  end
end

describe "OAuth", broken: true do
  include IntegrationTest

  before do
    Container.set Trello::Authorization, "AuthPolicy", OAuthPolicy
  end

  it "[!] actually does not enforce signature at all, only the keys are required" do
    OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, nil
    OAuthPolicy.token = OAuthCredential.new @access_token_key, nil

    pending "I would expect this to fail because I have signed with nil secrets" do
      -> { Client.get("/boards/#{@welcome_board}/") }.should raise_error
    end
  end
end
