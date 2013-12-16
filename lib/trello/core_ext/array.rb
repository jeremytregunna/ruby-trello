class Array
  def jsoned_into(obj)
    self.map { |element| element.jsoned_into(obj) }
  end
end