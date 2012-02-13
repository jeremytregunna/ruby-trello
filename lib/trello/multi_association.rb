module Trello
  class MultiAssociation < Association
    delegate :count, :to => :target

    def initialize(owner, target = [])
      super
      @proxy = AssociationProxy.new(self)
    end
  end
end