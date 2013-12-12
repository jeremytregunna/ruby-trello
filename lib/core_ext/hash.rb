class Hash
  def jsoned_into(obj)
    action = obj.kind_of?(Class) ? :new : :update_fields
    obj.send(action, self)
  end
end