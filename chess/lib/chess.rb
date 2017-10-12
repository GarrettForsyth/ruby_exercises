require "~/the_odin_project/ruby_exercises/chess/lib/board.rb"
require "~/the_odin_project/ruby_exercises/chess/lib/chess_rules.rb"
require "~/the_odin_project/ruby_exercises/chess/lib/move_parser.rb"
class Chess

  attr_accessor :game, :rules, :gameOver, :moveParser

  def initialize
    @game = []
    @rules = ChessRules.new
    @moveParser = MoveParser.new
    @ply = 0 # In chess, a 'ply' is like 'half a move'
    @gameOver = false
  end

  def board
    @game[-1] 
  end

  def startGame
    @board = Board.new
    @board.setPiecesAtStartingPositions
    @game << board
    turnPhase
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

  def turnPhase

    while not @gameOver do
      drawBoard
      move = promptMove
      @game << updateBoard(move)
      @gameOver = gameOver?
      @ply += 1
    end

    puts "Thanks for playing!"
  end

  def promptMove
    validMove = false
    while not validMove do
      print "#{whosTurn}'s move: "
      usersMove = gets.chomp!
      validMove = @moveParser.parseMove(@board,
                                        usersMove, 
                                        whosTurn.downcase.to_sym)
      
      puts "Invalid move." unless validMove
    end
    validMove
  end

  def whosTurn
    if @ply % 2 == 0 then return "White"
    else return "Black"
    end
  end

  def gameOver?
    false
  end

  def updateBoard(move)
    puts move.from
    @board.move(move)
  end

end
