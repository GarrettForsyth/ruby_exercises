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



require "~/the_odin_project/ruby_exercises/tic_tac_toe/lib/tic_tac_toe_board_graph.rb"

# Models the actions taken during a game of tic tac toe 
class TicTacToeGame

  attr_accessor :squares

  # Creates  square board of length n
  def initialize(size)
    @size = size
    @board = TicTacToeBoard.new size # whole board as a graph
    @squares  = @board.squares       
  end
  
  def markX(pos)
    newSquare = XSquare.new(pos, @squares[i].neighbours)
    @squares[pos] = newSquare
  end

  def markO(pos)
    newSquare = OSquare.new(pos, @squares[i].neighbours)
    @squares[pos] = newSquare
  end

  # Draws the current state of the board to std out in ASCII
  def drawBoard
    puts "Squares are numbered 0..n^2-1."
    for i in 0...@size
      drawRow(@size*i, @size*(i+1)-1)
      drawBar @size*3 unless i === @size-1
      puts ""
    end
  end

  # Helper that draws a single row of the board
  def drawRow(first, last)
    for i in first...last
      print " #{@squares[i].draw}|"
    end
    puts @squares[last].draw
  end    

  # Helper that draws a bar separating rows
  def drawBar(numDashes)
    numDashes.times{print "-"}
  end

  # Starts the game by prompting the first user for a 
  # and then draws the new board reflecting the user'choice
  def startGame
    counter = 0

    while (counter < @size**2) 
      if counter%2 == 0 then promptUser "Player X" end
      if counter%2 != 0 then promptUser "Player O" end
      puts counter
      drawBoard
      counter += 1
    end

    puts "Game Over. It's a tie!"
  end

  # Prompts the user until valid input is given
  def promptUser user
    input = ""
    while input == ""
      print "#{user} enter a sqaure: "

      input = gets.chomp
      input = validateInput(input, user)
      puts ""
    end
    if @board.checkLastMoveForWin(input.to_i)
      drawBoard
      puts "We have a winner!!!!"
      exit
    end
  end

  ####
  # Returns true if the user's input satisfies:
  #   - is a number
  #   - is between the range of the 0 and the board size -1
  #   - the numuber corresponds to an open square on the board
  #####
  #
  def validateInput input, user
    if not input =~ /^\d+$/
      puts "Please only enter nubmers."
      return ""
    elsif not input.to_i.between?(0,@size**2-1)
      puts "The number entered is not in [0 and #{@size**2-1}]."
      return ""
    elsif not @squares[input.to_i].instance_of? Square
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
