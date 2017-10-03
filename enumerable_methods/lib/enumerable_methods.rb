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

  # Returns all elements of an array or hash and their indices
  # Calls a block for each element, and then its respective index
  def my_each_with_index
    errorMessage = "#each_with_index  must be called on an Enumerable Object"
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable 
    return self unless block_given?
    return self unless self.any?   
    index = 0;
    # use .entries here to hashes are formatted right, e.g. they
    # return as [key, value]
    items = self.entries
    for i in 0...items.length do
      yield(items[i])
      yield(i)
    end
    self
  end

  # Returns an array/hash containing all elements of enum for which which
  # the given block returns a true value.
  def my_select(&block)
    errorMessage = "#my_select must be called on an Enumerable Object"
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable 
    return self unless self.any?   

    if self.instance_of? Array
      selection = []
      return selection unless block_given?
      self.my_each {|i| selection << i if yield(i)}
      return selection

    elsif self.instance_of? Hash
      selection = {}
      return selection unless block_given?

      # If only block param is passed, check for matching keys 
      if block.arity==1 
        i = 0
        self.my_each do |entry|
           selection[entry[0]]=entry[1] if yield(entry[0]) && i%2==0
           i+=1
        end
        return selection
      # If two block paramters are passed, check for matching keys
      # and values
      elsif block.arity==2
        self.my_each do |key,value|
           selection[key]=value if yield(key,value) 
        end                                                    
        return selection
      else
        raise(IllegalArgumentError, "Too many arguments to block")
      end
    else
      raise(IllegalArgumentError, "#my_select must be called on an Array or Hash.") 
    end
  end


  # Passes all elements to a block and returns true if they all
  # satisfiy a condition
  def my_all?
    errorMessage = "#my_all? must be called on an Enumerable Object"
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable      
    return true unless block_given?
    return true unless self.any?   
    my_each{|x| return false unless yield(x)}
    return true
  end

  # Passes all elements to a block and returns true if any of them
  # satisfiy the condition
  def my_any?

    errorMessage = "#my_any? must be called on an Enumerable Object"    
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable      
    return true unless block_given?
    return true unless self.any?   
    my_each{|x| return true if yield(x)}
    return false
  end

  # Passes each elemetn to a block and returns true if none of them
  # satisfy the block's condition
  def  my_none? 
    errorMessage = "#my_none? must be called on an Enumerable Object"
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable      
    return true unless block_given?
    return true unless self.any?   
    my_each{|x| return false if yield(x)}
    return true
  end

  # Returns the number of items in enum through enumeration.
  # If an argument is given, counts how many times this argument
  # occurs
  # if a block is given, returns how many times block is true
  def my_count arg=nil, &block
    errorMessage = "#my_none? must be called on an Enumerable Object"     
    raise(NoMethodError, errorMessage) unless self.is_a? Enumerable      
    return self.length if arg.nil? && !block_given?
    my_count_no_var(&block) if arg.nil?

    if block_given?
      counted_items = my_select(&block)
      return counted_items.length
    else
      counted_items = my_select{|x| x == arg}
      return counted_items.length
    end
  end

  def my_count_no_var &block
    if block_given?
      counted_items = my_select(&block)
      return counted_items.length
    else
      return self.length
    end
  end
  
  # returns a new array with the results of running the block once 
  # for every element in the enum
  def my_map(&block)
    mapped_array = []
    my_each{|x| mapped_array << &block.call(x)}
    mapped_array
  end

  # Combines all elements of enum byapplying a binary opeartion specified
  # by a block. alieas for 'inject"
  def my_reduce acc=self[0], &block
    my_each { |x| acc = block.call(acc, x)}
    acc
  end
end

