class String
  def json_into(kls)
    data = JSON.parse(self)
    if data.kind_of? Hash
      kls.new(JSON.parse(self))
    else
      data.map { |element| kls.new(element) }
    end
  end
end