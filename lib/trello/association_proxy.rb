require 'active_support/core_ext'

module Trello
  class AssociationProxy
    extend Forwardable
    alias :proxy_extend :extend

    instance_methods.each { |m| undef_method m unless m.to_s =~ /^(?:nil\?|send|object_id|to_a)$|^__|^respond_to|proxy_/ }

    def_delegators :@association, :owner, :target, :count

    def initialize(association)
      @association = association
      Array(association.options[:extend]).each { |ext| proxy_extend(ext) }
    end

    def proxy_assocation
      @association
    end

    def method_missing(method, *args, &block)
      if target.respond_to? method
        target.send(method, *args, &block)
      else
        super
      end
    end

    def ===(other)
      other === target
    end

    def to_ary
      proxy_assocation.dup
    end
    alias_method :to_a, :to_ary

    def <<(*records)
      proxy_assocation.concat(records) && self
    end
  end
end
