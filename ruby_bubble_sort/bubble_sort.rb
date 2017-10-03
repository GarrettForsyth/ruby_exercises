# Uses the bubble-sort algorithm 
# to sort an array. Works O(n^2)
def bubbleSort(arr)
  return if arr.nil?
  len = arr.length
  return arr if len <= 1

  for i in 0...len do
    for j in 0...len-i-1 do
      swap(j,j+1,arr) if (arr[j] > arr[j+1]) 
    end 
  end
  arr;
end

# helper swap function
def swap(a,b,arr)
  temp = arr[a]
  arr[a] = arr[b]
  arr[b] = temp
end

def bubbleSortBy(arr) 
  return if arr.nil?
  len = arr.length
  return arr if len <= 1
                                              
  for i in 0...len do
    for j in 0...len-i-1 do
      swap(j, j+1, arr) if yield(arr[j],arr[j+1]) >= 1
    end 
  end
  arr;
end

puts "Test 1:"
print bubbleSort([1,2,3,4,5])
puts ""
puts "Test 2"
print bubbleSort([5,4,3,2,1])
puts ""
puts "Test 3"
print bubbleSort([6,3,7,32,1,7,3,2,7,0,-5])
puts ""
puts "Test4"
puts ""
print bubbleSortBy(["hi", "hello", "hey"]) { |left, right| 
  left.length - right.length
}
puts ""
