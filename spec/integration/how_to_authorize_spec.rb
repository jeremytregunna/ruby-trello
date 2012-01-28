require 'spec_helper'
require 'integration/integration_test'

include Trello
include Trello::Authorization

class Container
  class << self
    def set(parent, name, value)
      parent.send :remove_const, name
      parent.const_set name, value
    end
  end
end

describe "Authorizing read-only requests" do
  include IntegrationTest

  it "Reading public resources requires just a developer public key" do
    uri = Addressable::URI.parse("https://api.trello.com/1/boards/4ed7e27fe6abb2517a21383d")
    uri.query_values = {
      :key => @developer_public_key
    }

    get(uri).code.should === 200
  end

  it "Reading private resources requires developer public key AND a member token" do
    uri = Addressable::URI.parse("https://api.trello.com/1/boards/#{@welcome_board}")
    uri.query_values = {
      :key => @developer_public_key,
      :token => @member_token
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

describe "Authorizing read/write requests" do
  include IntegrationTest

  context "given a valid access token" do
    before :all do
      OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
      OAuthPolicy.token = OAuthCredential.new @access_token_key, @access_token_secret
      Container.set Trello::Authorization, "AuthPolicy", OAuthPolicy
    end

    it "can add a board" do
      new_board = Board.create(:name => "An example")
      new_board.should_not be_nil
      new_board.id.should_not be_nil
      new_board.name.should == "An example"
      new_board.closed.should be_false
    end

    it "can read the welcome board" do
      welcome_board = Board.find @welcome_board
      welcome_board.name.should === "Welcome Board"
      welcome_board.id.should === @welcome_board
    end

    it "can close a board" 
  end
end
