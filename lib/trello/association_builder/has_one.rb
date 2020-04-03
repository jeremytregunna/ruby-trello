module Trello
  module AssociationBuilder
    class HasOne
      class << self
        def build(model_klass, name, options)
          model_klass.class_eval do
            define_method(:"#{name}") do |*args|
              opts = options.dup
              klass   = opts.delete(:via) || Trello.const_get(name.to_s.camelize)
              ident   = opts.delete(:using) || :id
              path    = opts.delete(:path)

              if path
                client.find(path, self.send(ident))
              else
                klass.find(self.send(ident))
              end
            end
          end
        end
      end
    end
  end
end