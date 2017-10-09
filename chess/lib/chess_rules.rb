require "~/the_odin_project/ruby_exercises/chess/lib/move.rb"
# This class defines methods that model the rules of chess
# TODO: REFACTOR IF CONDITIONS INTO SEPARATE FUNCTIONS
# ------> Keep functions smalllllllll!
class ChessRules

  ########################################################
  # A pawn move is legal if:
  #   - it moves one square forward to un-unoccupied square
  #   - it moves two squares forwards and:
  #       -it's the pawns first move
  #       -neither the square it crosses or lands on 
  #        is occupied
  #   - it can move one square diagonally forward if:
  #       -it is capturing a piece
  #       -(this included enpassant)
  ########################################################
  def isValidPawnMove?(move, board)
    possibleMoves = getPossibleMoves(move, board)
    x = move.piece.colour == :white ? 1 : -1 # pawns can only move forward

    # for each of the possible moves, check
    possibleMoves.each do |move|

      squareInbetween = board.getSquaresInbetween(move.from, move.to)
      # validate moving forward one
      if((x*(move.to[1].to_i - move.from[1].to_i) == 1) && # one row difference
         (move.to[0] == move.from[0]) &&                   # same column
         (not board.getSquare(move.to).occupied?) )        # destination unoccupied
        return true

      ## validates moving forward 2 if first move
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
  end

  def isValidRookMove?(move, board)
    possibleMoves = getPossibleMoves(move,board)

    possibleMoves.each do |move|
      if( (move.to[0] == move.from[0] || move.to[1] == move.from[1]) && ## same row/column
          (not impeded?(move, board)) && 
          (board.getSquare(move.to).occupied? == false || 
          (board.getSquare(move.to).occupied? == true &&
          board.getSquare(move.to).occupancy.colour != move.piece.colour)))
        return true
      else
        return false
      end
    end
  end

  def isValidKnightMove?(move, board)
    possibleMoves = getPossibleMoves(move, board)

    possibleMoves.each do |move|

              # Enforce L Shape
      if( (((move.to[1].to_i - move.from[1].to_i).abs == 2 &&
              (move.to[0].ord - move.from[0].ord).abs == 1) ||
        
          ((move.to[0].ord - move.from[0].ord).abs == 2 &&
              (move.to[1].to_i - move.from[1].to_i).abs == 1)) &&
        

          # can only land on empty squares or capture
          (board.getSquare(move.to).occupied? == false || 
          (board.getSquare(move.to).occupied? == true &&
          board.getSquare(move.to).occupancy.colour != move.piece.colour)))
        return true

      else
        return false
      end
    end
  end

  def isValidBishopMove?(move, board)
    possibleMoves = getPossibleMoves(move, board)

    possibleMoves.each do |move|

          # Enforce diagonal i.e. rise == run 
      if( ((move.to[0].ord - move.from[0].ord).abs == 
            (move.to[1].to_i - move.from[1].to_i).abs) &&

           (not impeded?(move, board)) && 
           # can only land on empty squares or capture
           (board.getSquare(move.to).occupied? == false || 
           (board.getSquare(move.to).occupied? == true &&
           board.getSquare(move.to).occupancy.colour != move.piece.colour)))
        return true
      else
        return false
      end
    end
  end

  # Returns true if there is a piece blocking the move
  def impeded?(move, board)
    coords = board.getSquaresInbetween(move.from,move.to)
    coords.each do |coord|
      return true if board.getSquare(coord).occupied?
    end
    return false
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
      # Make sure the piece trying to be moved exists
      if(board.getSquare(move.from).occupied? &&
         board.getSquare(move.from).occupancy.class == move.piece.class &&
         board.getSquare(move.from).occupancy.colour == move.piece.colour)
         possibleMoves << move
      end
    end
    possibleMoves
  end

  # Tries to infer where piece is coming from 
  # Returns an array of coordinates of squares that contain move.piece
  # on board
  def getPossibleFrom move,board
    possibleFrom = []
    board.pieces[move.piece.colour][move.piece.class.to_s.to_sym].each do |coord, piece|
      possibleFrom << coord
    end
    possibleFrom
  end

end
