require "~/the_odin_project/ruby_exercises/chess/lib/move.rb"
# This class defines methods that model the rules of chess
class ChessRules

  ########################################################
  # A pawn move is legal if:
  #   - it moves one square foward to un unoccupied sqaure
  #   - it moves two squares fowards and:
  #       -it's the pawns first move
  #       -neither the square it crosses or lands on 
  #        is occupied
  #   - it can move one sqaure diagonally foward if:
  #       -it is captruing a piece
  #       -(this included enpassant)
  ########################################################
  def isValidPawnMove?(move, board)
    possibleMoves = getPossibleMoves(move, board)
    x = move.piece.colour == :white ? 1 : -1 # pawns can only move foward

    # one move ahead:


    
    
  end

  # Returns a list of possible moves that move.piece could make on board 
  def getPossibleMoves(move, board)
    possibleMoves = []
    if move.from.nil?
      possibleFrom = getPossibleFrom(move,board)
      possibleFrom.each do |from|
        possibleMove = Move.new(move.pieace, move.to, from)
      end
    else
      possibleMoves << move
    end
    possibleMoves
  end

  # Tries to infer where piece is coming from 
  # Returns an array of coordiantes of squares that contain move.piece
  # on board
  def getPossibleFrom move,board
    possibleFrom = []
    board[move.piece.colour][move.piece].each do |piece, coord|
      possibleMoves << coord
    end
    possibleFrom
  end

end
