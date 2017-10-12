require './chess.rb'
require './move.rb'
require './board.rb'

originalBoard = Board.new
originalBoard.setSquare("a2", Pawn.new(:white,true))

newBoard = Board.new
newBoard.setSquare("a4", Pawn.new(:white,false))

m = Move.new(originalBoard, originalBoard.getPieceAt("a2"), "a4")


game = Chess.new
game.startGame
