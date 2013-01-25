module Trello
  class MultiAssociation < Association
    extend Forwardable

    def_delegator :target, :count

    def initialize(owner, target = [])
      super
      @proxy = AssociationProxy.new(self)
    end
  end
end
