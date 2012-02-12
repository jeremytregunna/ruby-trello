class String
  # Decodes some JSON text in the receiver, and marshals it into a class specified
  # in _obj_. If _obj_ is not a class, then we marshall the data into that instance
  # via _update_fields_.
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
  def json_into(obj)
    data = JSON.parse(self)
    action = obj.kind_of?(Class) ? :new : :update_fields
    if data.kind_of? Hash
      obj.send(action, JSON.parse(self))
    else
      data.map { |element| obj.send(action, element) }
    end
  rescue JSON::ParserError => json_error
    if json_error.message =~ /model not found/
      Trello.logger.error "Could not find that record."
      raise Trello::Error, "Request could not be found."
    elsif json_error.message =~ /A JSON text must at least contain two octets/
    else
      Trello.logger.error "Unknown error."
      raise
    end
  end
end