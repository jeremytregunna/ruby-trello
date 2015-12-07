warn "Use of trello/core_ext/string is deprecated. Use Trello::JsonUtils instead"
class String
  def json_into(obj, encoding = 'UTF-8')
    obj.from_response(self, encoding)
  end
end
