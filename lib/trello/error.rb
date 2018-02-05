module Trello
  class Error < StandardError

    attr_reader :status_code

    def initialize(message, status_code=nil)
      @status_code = status_code
      super(message)
    end

  end
end