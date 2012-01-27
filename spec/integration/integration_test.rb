module IntegrationTest
  def self.included(clazz)
    clazz.class_eval do
      before :all do
        # Getting developer/member key
        # 1. https://trello.com/1/appKey/generate
        # 2. https://trello.com/1/connect?key=<public_key_here>&name=RubyTrelloIntegrationTests&response_type=token
        # See: https://trello.com/board/trello-public-api/4ed7e27fe6abb2517a21383d

        @developer_public_key = ENV["DEVELOPER_PUBLIC_KEY"]
        @developer_secret     = ENV["DEVELOPER_SECRET"]
        @member_token         = ENV["MEMBER_TOKEN"]
        @welcome_board        = ENV["WELCOME_BOARD"]
        @access_token_key     = ENV["ACCESS_TOKEN_KEY"]
        @access_token_secret  = ENV["ACCESS_TOKEN_SECRET"]
        
        WebMock.disable!
      end    
    end
  end

  protected

  def get(uri)
    require "rest_client"
    RestClient.get uri.to_s
  end
end
