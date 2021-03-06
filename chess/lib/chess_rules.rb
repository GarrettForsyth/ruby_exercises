require "~/the_odin_project/ruby_exercises/chess/lib/move.rb"
# This class defines methods that model the rules of chess

class ChessRules

  def isLegalMove?(move)
    case move.piece
    when Pawn
      return isValidPawnMove?(move)
    when Knight
      return isValidKnightMove?(move)
    when Rook
      return isValidRookMove?(move)
    when Bishop
      return isValidBishopMove?(move)
    when Queen
      return isValidQueenMove?(move)
    when King
      return isValidKingMove?(move)
    else
      return false
    end
  end

  def isValidPawnMove?(move)
    possibleMoves = getPossibleMoves(move)
    dir = move.piece.colour == :white ? 1 : -1 # pawns can only move forward

    possibleMoves.each do |move|
      return move if isLegalOneSquarePawnMove?(move, dir)
      return move if isLegalTwoSquarePawnMove?( move, dir)
      return move if isLegalPawnCapture?(move, dir)
    end
    return false
  end

  def isLegalOneSquarePawnMove?(move, dir)
     return dir*(move.to[1].to_i - move.from[1].to_i) == 1 &&  # one row difference     
            move.to[0] == move.from[0] &&                      # same column
            isLandingOnEmptySquare?(move)                # destination unoccupied
  end

  def isLegalTwoSquarePawnMove?(move, dir)
    return dir*(move.to[1].to_i - move.from[1].to_i) == 2 &&   # two row difference     
           move.to[0] == move.from[0] &&                       # same column
           isLandingOnEmptySquare?(move) &&              # destination unoccupied
           isNotImpeded?(move) &&                        # not blocked
           move.piece.firstMove                                # pawn's first move
  end

  def isLegalPawnCapture?(move, dir)
    return ((move.to[0].ord - move.from[0].ord).abs == 1) &&     # one row up or down 
           (dir*(move.to[1].to_i - move.from[1].to_i) == 1) &&   # one col difference
           isCapture?(move)
  end

  def isValidRookMove?(move)
    possibleMoves = getPossibleMoves(move)
    possibleMoves.each do |move|
      return move if isMoveHorizontalOrVerticalLine?(move) &&
                     isNotImpeded?(move) && 
                     isCaptureOrLandingOnEmptySquare?(move)
    end
    return false
  end

  def isMoveHorizontalOrVerticalLine?(move)
    return move.to[0] == move.from[0] || move.to[1] == move.from[1]
  end

  def isValidKnightMove?(moved)
    possibleMoves = getPossibleMoves(moved)
    possibleMoves.each do |move|
      return move if isMoveLShaped?(move) && 
                     isCaptureOrLandingOnEmptySquare?(move)
    end
    return false
  end

  def isMoveLShaped?(move)
    return ((move.to[1].to_i - move.from[1].to_i).abs == 2 &&
            (move.to[0].ord - move.from[0].ord).abs == 1) ||
                                                            
           ((move.to[0].ord - move.from[0].ord).abs == 2 &&
            (move.to[1].to_i - move.from[1].to_i).abs == 1) 
  end

  def isValidBishopMove?(move)
    possibleMoves = getPossibleMoves(move)
    possibleMoves.each do |move|
      return move if isMoveAlongDiagonal?(move) &&
                     isNotImpeded?(move) && 
                     isCaptureOrLandingOnEmptySquare?(move)
    end
    return false
  end

  def isMoveAlongDiagonal?( move)
    return (move.to[0].ord - move.from[0].ord).abs == 
           (move.to[1].to_i - move.from[1].to_i).abs
  end


  def isValidQueenMove?(move)
    possibleMoves = getPossibleMoves(move)
    possibleMoves.each do |move|
      return move if (isValidRookMove?(move) || isValidBishopMove?(move))
    end
    return false
  end

  def isValidKingMove?(move)
    possibleMoves = getPossibleMoves(move) 
    possibleMoves.each do |move|
      return move if ((isMoveOneSquareAway?(move) &&
                     isCaptureOrLandingOnEmptySquare?(move)) ||
                     isCastleShort?(move) ||
                     isCastleLong?(move))
    end
    return false
  end

  def isMoveOneSquareAway?(move)
    return (move.to[0].ord - move.from[0].ord).between?(-1,1)   &&
           (move.to[1].to_i - move.from[1].to_i).between?(-1,1) 
  end

  def isCastleShort?(move)
    if move.piece.colour == :white 
      from = "e1"; to = "g1"; r = "h1";oc=:black  
    else
      from = "e8";to = "g8";r= "h8";oc=:white 
    end

    return false if move.to != to || move.from != from 

    king = move.board.getPieceAt(from)
    rook = move.board.getPieceAt(r)

    return false unless king.instance_of?(King) && king.firstMove
    return false unless rook.instance_of?(Rook) &&  rook.firstMove

    return false if isInCheck?(move.piece.colour, move.board)
    squaresInbetween = move.board.getSquaresInbetween(move.from, r)
    squaresInbetween.each do |square|
      return false if isSquareAttackedBy?(square, oc, move.board)
    end
    return true
  end 

  def isCastleLong?(move)
    if move.piece.colour == :white 
      from = "e1"; to = "c1"; r = "a1";oc=:black  
    else
      from = "e8";to = "c8";r= "a8";oc=:white 
    end
                                                                    
    return false if move.to != to || move.from != from 
                                                                    
    king = move.board.getPieceAt(from)
    rook = move.board.getPieceAt(r)
                                                                    
    return false unless king.instance_of?(King) && king.firstMove
    return false unless rook.instance_of?(Rook) &&  rook.firstMove
                                                                    
    return false if isInCheck?(move.piece.colour, move.board)
    squaresInbetween = move.board.getSquaresInbetween(move.from, r)
    # don't include the b file when checking if castling into an attack
    squaresInbetween[0..-2].each do |square|
      return false if isSquareAttackedBy?(square, oc, move.board)
    end
    return true
  end 






  def isInCheck?(colour, board)
    kingCoord = board.getCoordOf(King.new(colour))[0]
    colour == :white ? opponentColour = :black : opponentColour = :white
    return isSquareAttackedBy?(kingCoord, opponentColour.to_sym, board)
  end

  # Iterates over all of a colours  pieces to see if any can legally attack a square
  def isSquareAttackedBy?(coord,colour, board)
    board.pieces[colour].each do |pieceType, listOfCoord|
      listOfCoord.each do |fromCoord, piece| 
        m = Move.new(board, piece, coord, fromCoord)
        return true if isLegalMove?(m)
      end
    end
    return false
  end

  def isCaptureOrLandingOnEmptySquare?(move)
      return isLandingOnEmptySquare?(move) || isCapture?(move)  

  end

  def isCapture?(move)
    board = move.board
    return board.getSquare(move.to).occupied? == true &&
           board.getSquare(move.to).occupancy.colour != move.piece.colour
  end

  def isLandingOnEmptySquare?(move)
      return move.board.getSquare(move.to).occupied? == false  
  end

  # Returns true if there are no pieces blocking the move
  def isNotImpeded?(move)
    coords = move.board.getSquaresInbetween(move.from,move.to)
    coords.each do |coord|
      return false if move.board.getSquare(coord).occupied?
    end
    return true
  end


  # Returns a list of possible moves that move.piece could make on board 
  def getPossibleMoves(move)
    board = move.board
    possibleMoves = []
    if move.from.nil?
      possibleFrom = getPossibleFrom(move)
      possibleFrom.each do |from|
        possibleMove = Move.new(board, move.board.getSquare(from).occupancy, move.to, from)
        possibleMoves << possibleMove
      end
    else
      # Make sure the piece trying to be moved exists
      if(board.getSquare(move.from).occupied? &&
         board.getSquare(move.from).occupancy.class == move.piece.class &&
         board.getSquare(move.from).occupancy.colour == move.piece.colour)
         move.piece = move.board.getSquare(move.from).occupancy
         possibleMoves << move
      end
    end
    possibleMoves
  end

  # Tries to infer where piece is coming from 
  # Returns an array of coordinates of squares that contain move.piece
  # on board
  def getPossibleFrom move
    possibleFrom = []
    move.board.pieces[move.piece.colour][move.piece.class.to_s.to_sym].each do |coord, piece|
      possibleFrom << coord
    end
    possibleFrom
  end

end
