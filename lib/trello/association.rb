module Trello
  class Association
    attr_reader :owner, :target, :options, :proxy

    def initialize(owner, target)
      @owner  = owner
      @target = target
      @options = {}
      if target.is_a?(Array)
        target.each { |array_element| array_element.client = owner.client }
      end
    end
  end
end
