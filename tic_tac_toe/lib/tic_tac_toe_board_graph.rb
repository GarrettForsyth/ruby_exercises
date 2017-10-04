# This class represents a tic tac toe board as a graph
#  It is implemented as an adjacency list
class TicTacToeBoard

  attr_accessor :squares

  # Creates a new tic toe board
  def initialize(n=3)
    raise(ArgumentError.new "Board must be larger than 1 square!") if n <=1
    @board_length = n
    @squares = Array.new
    for i in 0...n*n
      @squares[i] = Square.new(i)
      addNeighbours(i)
    end
  end

  # Prints graph for debugging
  def printGraph
    for i in 0...@board_length*@board_length
      puts "#{i} has neighbours #{@squares[i].neighbours}"
    end
  end

  def addNeighbours(position)

    # Check if this position is on the edge of the board
    # add calls the appropriate function to add its neighbours
    if isTopRow?(position, @board_length)
      if isTopLeftCorner?(position, @board_length)
        addTopLeftCornerNeighbours(position)
      elsif isTopRightCorner?(position, @board_length)
        addTopRightCornerNeighbours(position)
      else
        addTopRowNeighbours(position)
      end

    elsif isBottomRow?(position, @board_length)
      if isBottomLeftCorner?(position, @board_length)
        addBottomLeftCornerNeighbours(position)
      elsif isBottomRightCorner?(position, @board_length)
        addBottomRightCornerNeighbours(position)
      else
        addBottomRowNeighbours(position)
      end

    elsif isLeftCol?(position, @board_length)
      addLeftColNeighbours(position)

    elsif isRightCol?(position, @board_length)
      addRightColNeighbours(position)

    else
      addInsideSquareNeighbours(position)
    end
  end

  def addInsideSquareNeighbours(i)
    @squares[i].neighbours << (i - 1)
    @squares[i].neighbours << (i + 1)

    @squares[i].neighbours << (i - @board_length - 1)
    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length + 1)


    @squares[i].neighbours << (i + @board_length - 1)
    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length + 1)
  end

  def addTopRowNeighbours(i)
    @squares[i].neighbours << (i - 1)
    @squares[i].neighbours << (i + 1)

    @squares[i].neighbours << (i + @board_length - 1) 
    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length + 1)
  end

  def addBottomRowNeighbours(i)
    @squares[i].neighbours << (i - 1)
    @squares[i].neighbours << (i + 1)

    @squares[i].neighbours << (i - @board_length - 1)
    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length + 1)
  end

  def addLeftColNeighbours(i)
    @squares[i].neighbours << (i + 1)

    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length + 1)

    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length + 1)
  end

  def addRightColNeighbours(i)

    @squares[i].neighbours << (i - 1)

    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length - 1)

    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length - 1)
  end

  def addTopLeftCornerNeighbours(i)
    @squares[i].neighbours << (i + 1)
    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length + 1)
  end

  def addTopRightCornerNeighbours(i)
    @squares[i].neighbours << (i - 1)
    @squares[i].neighbours << (i + @board_length)
    @squares[i].neighbours << (i + @board_length - 1)
  end

  def addBottomRightCornerNeighbours(i)
    @squares[i].neighbours << (i - 1)
    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length - 1)
  end

  def addBottomLeftCornerNeighbours(i)
    @squares[i].neighbours << (i + 1)
    @squares[i].neighbours << (i - @board_length)
    @squares[i].neighbours << (i - @board_length + 1)
  end

  def isTopRow?(position, board_length)
    position < board_length
  end

  def isBottomRow?(position, board_length)
    position >= (board_length-1)*board_length
  end

  def isRightCol?(position, board_length)
    (position+1) %board_length == 0
  end

  def isLeftCol?(position, board_length)
    position%board_length == 0
  end

  def isTopLeftCorner?(position, board_length)
    isLeftCol?(position, board_length) && isTopRow?(position, board_length)
  end

  def isTopRightCorner?(position, board_length)
    isRightCol?(position, board_length) && isTopRow?(position, board_length)
  end

  def isBottomRightCorner?(position, board_length)
    isRightCol?(position, board_length) && isBottomRow?(position, board_length)
  end

  def isBottomLeftCorner?(position, board_length)
    isLeftCol?(position, board_length) && isBottomRow?(position, board_length)
  end

  def checkLastMoveForWin(lastMove)
    return true if (checkRowForWin(lastMove) || 
                    checkColForWin(lastMove) ||
                    checkNegativeDiagonalForWin(lastMove) ||
                    checkPositiveDiagonalsForWin(lastMove))
    return false
  end

  def checkRowForWin(lastMove)
    rowStart = (lastMove/@board_length)*@board_length # use int division
    rowEnd   = rowStart + (@board_length-1)
    for i in rowStart..rowEnd do
      return false if !@squares[i].instance_of? squares[lastMove].class
    end
    return true
  end

  def checkColForWin(lastMove)
    colStart = lastMove % @board_length
    for i in 0...@board_length do 
      return false if !@squares[i*@board_length+colStart].instance_of? squares[lastMove].class
    end
    return true
  end

  def checkPositiveDiagonalsForWin(lastMove)
    for i in 0...@board_length
      return false if !@squares[i*(@board_length+1)].instance_of? squares[lastMove].class 
    end
    return true
  end

  def checkNegativeDiagonalForWin(lastMove)
    for i in 1..@board_length
      return false if !squares[i*(@board_length-1)].instance_of? squares[lastMove].class
    end
    return true
  end
end

# This class models a square in the tic tac toe board
# It it used as the nodes in the tic tac toe graph
class Square
  attr_accessor :board_location, :neighbours
  
  def initialize(board_location, neighbours=[])
    @board_location = board_location
    @neighbours = neighbours
  end

  def draw
    print " "
  end

end

# Model X squares
class XSquare < Square

  def initialize(board_location, neighbours=[])
    super(board_location,neighbours)
  end

  def draw
    print "X"
  end
end

# Model O squares
class OSquare < Square

  def initialize(board_location, neighbours=[])
    super(board_location,neighbours)
  end

  def draw
    print "O"
  end
end                                               

