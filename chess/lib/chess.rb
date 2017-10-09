require "~/the_odin_project/ruby_exercises/chess/lib/board.rb"
require "~/the_odin_project/ruby_exercises/chess/lib/chess_rules.rb"
class Chess

  attr_accessor :board, :rules

  def initialize
    @board = Board.new
    @rules = ChessRules.new
    @ply = 0 # In chess, a 'ply' is like 'half a move'
  end

  def startGame
    @board.setPiecesAtStartingPositions
    drawBoard
    promptMove
  end

  def getSquare(coordiante)
    @board.getSquare(coordiante)
  end

  def setSquare(coordiante, piece)
    @board.setSquare(coordiante,piece)
  end

  def drawBoard
    @board.draw
  end

  def promptMove
    print "#{whosTurn}'s move: "
    usersMove = gets
  end

  def whosTurn
    if @ply % 2 == 0 then return "White"
    else return "Black"
    end
  end


end
