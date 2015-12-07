warn "Use of trello/core_ext/hash is deprecated. Use Trello::JsonUtils instead"
class Hash
  def jsoned_into(obj)
    obj.from_json(self)
  end
end
