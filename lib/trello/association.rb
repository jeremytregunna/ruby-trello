module Trello
  class Association
    attr_reader :owner, :target, :options, :proxy

    def initialize(owner, target)
      @owner  = owner
      @target = target
      @options = {}
    end
  end
end