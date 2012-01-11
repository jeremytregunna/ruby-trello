class String
  # Decodes some JSON text in the receiver, and marshals it into a class specified
  # in _kls_.
  #
  # For instance:
  #
  #   class Stuff
  #     attr_reader :a, :b
  #     def initialize(values)
  #       @a = values['a']
  #       @b = values['b']
  #     end
  #   end
  #   thing = '{"a":42,"b":"foo"}'.json_into(Stuff)
  #   thing.a == 42
  #   thing.b == "foo"
  def json_into(kls)
    data = JSON.parse(self)
    if data.kind_of? Hash
      kls.new(JSON.parse(self))
    else
      data.map { |element| kls.new(element) }
    end
  end
end