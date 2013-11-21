class Array
  def jsoned_into(obj)
    self.map { |element| element.hashed_into(obj) }
  end
end