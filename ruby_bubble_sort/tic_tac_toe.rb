# Possible extension:
#   Check victory condition for an arbitrary board size:
#     - change data structure of board to a graph
#     and add a check for a victory condtion by
#     doing a bfs each time a square is entered
#     search only through neighbours that match he same
#     square class (e.g. only search O neighbours or X
#     neighbours)
#     - if the path is of the same length as @size, the player
#     has won.  

# Class representing a Square on the tic tac toe board
class TicTacToeSquare

  def initialize(squareNum)
    @locationOnBoard = squareNum
  end
  
  def draw
    print " "
  end

end

#Models X Squares
class XSquare < TicTacToeSquare

  def initialize(squareNum)
    super(squareNum)
  end

  def draw
    print "X"
  end
end

#Models O Squares
class OSquare < TicTacToeSquare

  def initialize(squareNum)
    super(squareNum)  
  end

  def draw
    print "O"
  end
end

#Models a tic tac toe board
class TicTacToeBoard

  def initialize(size)
    @size = size
    @squares = Array.new
    for i in 0...size**2
      @squares[i] = TicTacToeSquare.new(i) 
    end
  end
  
  def markX(pos)
    @squares[pos] = XSquare.new(pos)
  end

  def markO(pos)
    @squares[pos] = OSquare.new(pos)
  end

  def drawBoard
    puts "Sqaures are numbered 0..n^2-1."
    for i in 0...@size
      drawRow(@size*i, @size*(i+1)-1)
      drawBar @size*3 unless i === @size-1
      puts ""
    end
  end

  def drawRow(first, last)
    for i in first...last
      print " #{@squares[i].draw}|"
    end
    puts @squares[last].draw
  end    

  def drawBar(numDashes)
    numDashes.times{print "-"}
  end

  def startGame
    counter = 0

    while (counter <= @size**2) 
      if counter%2 == 0 then promptUser "Player X" end
      if counter%2 != 0 then promptUser "Player O" end
      puts counter
      drawBoard
      counter += 1
    end
  end

  def promptUser user
    input = ""
    while input == ""
      print "#{user} enter a sqaure: "

      input = gets.chomp
      input = validateInput(input, user)
      puts ""
    end
  end

  def validateInput input, user
    if not input =~ /^\d+$/
      puts "Please only enter nubmers."
      return ""
    elsif not input.to_i.between?(0,@size**2-1)
      puts "The number entered is not in [0 and #{@size**2-1}]."
      return ""
    elsif not @squares[input.to_i].instance_of? TicTacToeSquare
      puts "This square is already occupied."
      return ""
    else
      if user == "Player X" then
        @squares[input.to_i] = XSquare.new(input.to_i)
      else                      
        @squares[input.to_i] = OSquare.new(input.to_i)
      end
      return input
    end
  end
end

testBoard = TicTacToeBoard.new(3)
testBoard.drawBoard
testBoard.startGame
