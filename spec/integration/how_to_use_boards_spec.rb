require 'spec_helper'
require 'integration/integration_test'

describe "how to use boards", broken: true do
  include IntegrationTest

  context "given a valid access token" do
    before :all do
      OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
      OAuthPolicy.token = OAuthCredential.new @access_token_key, @access_token_secret
      Container.set Trello::Authorization, "AuthPolicy", OAuthPolicy
    end

    after do
      if @new_board and false == @new_board.closed?
        @new_board.update_fields 'closed' => true
        @new_board.save
      end
    end

    it "can add a board" do
      @new_board = Board.create(name: "An example")
      @new_board.should_not be_nil
      @new_board.id.should_not be_nil
      @new_board.name.should == "An example"
      @new_board.should_not be_closed
    end

    it "can read the welcome board" do
      welcome_board = Board.find @welcome_board
      welcome_board.name.should === "Welcome Board"
      welcome_board.id.should === @welcome_board
    end

    it "can close a board" do
      @new_board = Board.create(name: "[#{Time.now}, CLOSED] An example")

      @new_board.update_fields 'closed' => true
      @new_board.save

      Board.find(@new_board.id).should be_closed
    end

    it "can list all boards" do
      Board.from_response(Client.get("/members/me/boards/")).should be_an Array
    end
  end
end
