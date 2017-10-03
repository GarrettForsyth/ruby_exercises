module  Enumerable

  # Returns all elements of an array or hash
  # Calls a block once for each element in self
  def my_each
    errorMessage = "#each must be called on an Enumerable Object"
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable 
    return self unless block_given?
    return self unless self.any?   
    items = self.to_a
    for i in 0...items.length do
      yield(items[i])  
    end
    self
  end

end
