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

    # for each of the possible moves, check
    possibleMoves.each do |move|

      squareInbetween = board.getSquaresInbetween(move.from, move.to)
      # validate moving foward one
      if((x*(move.to[1].to_i - move.from[1].to_i) == 1) && # one row difference
         (move.to[0] == move.from[0]) &&                   # same column
         (not board.getSquare(move.to).occupied?) )        # destination unoccupied
        return true

      ## validates movoing foward 2 if first move
      elsif((x*(move.to[1].to_i - move.from[1].to_i) == 2) &&    # two row difference     
           (move.to[0] == move.from[0]) &&                       # same column
           (not board.getSquare(move.to).occupied?) &&           # destination unoccupied
           (not board.getSquare(squareInbetween[0]).occupied?)&& # not blocked
           (move.piece.firstMove))                               # pawn's first move
          return true

      ### validates pos captures
      elsif( ((move.to[0].ord - move.from[0].ord).abs == 1) &&     # one row up or down
             (x*(move.to[1].to_i - move.from[1].to_i) == 1) && # one col difference
             (board.getSquare(move.to).occupied?) && 
             (board.getSquare(move.to).occupancy.colour != move.piece.colour)) # capture
          return true 
             
      else 
        return false
      end
    end
    # one move ahead:


    
    
  end

  # Returns a list of possible moves that move.piece could make on board 
  def getPossibleMoves(move, board)
    possibleMoves = []
    if move.from.nil?
      possibleFrom = getPossibleFrom(move,board)
      possibleFrom.each do |from|
        possibleMove = Move.new(move.piece, move.to, from)
        possibleMoves << possibleMove
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
    board.pieces[move.piece.colour][move.piece.class.to_s.to_sym].each do |coord, piece|
      possibleFrom << coord
    end
    possibleFrom
  end

end
