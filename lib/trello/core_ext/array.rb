warn "Use of trello/core_ext/array is deprecated. Use Trello::JsonUtils instead"
class Array
  def jsoned_into(obj)
    obj.from_json(self)
  end
end
