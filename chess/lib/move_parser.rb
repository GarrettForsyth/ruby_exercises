require '~/the_odin_project/ruby_exercises/chess/lib/chess_rules.rb'

# This class attempts to parse a string to create a Move Object
#
class MoveParser

  def initialize
    @rules = ChessRules.new
  end

  def parseMove(board, usersMove, colour=:white)
    validFormatMove = formatMove(board, usersMove, colour)
    return false if validFormatMove == false
    legalMove = @rules.isLegalMove?(validFormatMove)
    return legalMove if legalMove
    return false
  end

  # Cases for valid moves
  #
  # =>  Typical moving of a piece: Nd5 , Pe4, Qd6                               
  # =>  Pawn moves: e5, a5
  # =>  Capturing pieces: Nxe4
  # =>  Castling: O-O-O , O-O
  # =>  Promotion: e8=Q , b1=N
  # =>  checks: Bb5+
  # =>  Two of same piece can move to square: Nb4-d3
  # =>  enpassant : exd5  
  # 
  def formatMove(board,usersMove, colour=:white)
    return false if usersMove.length < 2
    @colour = colour
    @board = board
    usersMove = cleanMove(usersMove)

    case usersMove.length
    when 2 
      return false unless validLengthTwo?(usersMove)
      return lengthTwoMove(usersMove)

    when 3
      return false unless validLengthThree?(usersMove)
      return lengthThreeMove(usersMove)
      
    when 4 
      #note: must be a promotion, so upcae last character 
      # i.e. a8=q --> a8=Q
      usersMove = usersMove[0...-1] + usersMove[-1].upcase
      return false unless validLengthFour?(usersMove)
      return lengthFourMove(usersMove)
                                                                             
    when 5 

      if usersMove.include?("=")
        usersMove = usersMove[0...-1] + usersMove[-1].upcase
      end


      return false unless validLengthFive?(usersMove)
      return lengthFiveMove(usersMove)
      
    else 
      return false
    end
  end

  # Gets rid of unnecessary characters used in common notation 
  def cleanMove usersMove
    usersMove = usersMove[0] +
                usersMove[1..-1].downcase.gsub("x","").gsub("-","").gsub("+","")
  end

  #must be a pawn move or short castle
  def validLengthTwo? usersMove
    return true if usersMove == "oo" || usersMove == "Oo"
    return false unless /^[a-h][1-8]/ =~ usersMove
    return true
  end

  #standard move or long caslte or pawn capture
  def validLengthThree? usersMove
    return true if /[a-h][a-h][1-8]/ =~ usersMove
    return true if usersMove == "ooo" || usersMove == "Ooo"
    return false unless /^[RBNQKP][a-h][1-8]/ =~ usersMove
    return true
  end

  
  # must be a promotion
  def validLengthFour? usersMove
    return false unless /^[a-h][81]=[RNBQ]/ =~ usersMove
    return true
  end

  # must be two pieces able to move to square or promotion
  def validLengthFive? usersMove
    if (not /^P[abcedfgh][81]=[RNBQ]/ =~ usersMove) &&
       (not /^[RNBQ][a-h][1-8][a-h][1-8]/ =~ usersMove)
      return false
    else
      return true
    end
  end

  #gets the piece fromthe first character
  def getPiece move
    case move[0]
    when /^[Pa-h]/
      return Pawn.new(@colour)
    when "R" 
      return Rook.new(@colour)
    when "N" 
      return Knight.new(@colour)
    when "B"
      return Bishop.new(@colour)
    when "Q"
      return Queen.new(@colour)
    when "K" 
      return King.new(@colour)
    else 
      return false
    end
  end

  # Creates a short castle or pawn move
  def lengthTwoMove(usersMove)
    if usersMove == "oo" || usersMove == "Oo"
      @colour == :white ? to = "g1" : to = "g8"
      return Move.new(@board, King.new(@colour), to)
    else
      to = usersMove
      return Move.new(@board, Pawn.new(@colour), to)
    end
  end

  def lengthThreeMove(usersMove)
    if usersMove == "ooo" || usersMove == "Ooo"
      @colour == :white ? to = "c1" : to = "c8"
      return Move.new(@board, King.new(@colour), to)
    else
      to = usersMove[1..2]
      return Move.new(@board, getPiece(usersMove), to )
    end
  end

  #TODO might need to upcase when extracting which piece to promote to
  def lengthFourMove(usersMove)
    to = usersMove[0..1]
    return Move.new(@board, Pawn.new(@colour), to)
  end

  def lengthFiveMove(usersMove)
    if usersMove.include?("=")
      to = usersMove[1..2]
      return Move.new(@board, Pawn.new(@colour), to)
    else
      from = usersMove[1..2]
      to = usersMove[3..4]
      return Move.new(@board, getPiece(usersMove), to, from)
    end
  end

end
