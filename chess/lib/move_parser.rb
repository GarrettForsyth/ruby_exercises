# This class attempts to parse a string to create a Move Object
#
class MoveParser

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
  def validMoveFormat? usersMove
    usersMove = cleanMove(usersMove)

    case usersMove.length
    when 2 
      return validLengthTwo?(usersMove)

    when 3
      return validLengthThree?(usersMove)
      
    when 4 
      return validLengthFour?(usersMove)
                                                                             
    when 5 
      validLengthFive?(usersMove)
      
    else 
      return false
    end
  end

  # Gets rid of unnecessary characters used in common notation 
  def cleanMove usersMove
    usersMove = usersMove.downcase.gsub("x","").gsub("-","").gsub("+","")
  end

  #must be a pawn move or short castle
  def validLengthTwo? usersMove
    return true if usersMove == "oo"
    return false unless /^[a-h][1-8]/ =~ usersMove
    return true
  end

  #standard move or long caslte or pawn capture
  def validLengthThree? usersMove
    return true if /[a-h][a-h][1-8]/ =~ usersMove
    return true if usersMove == "ooo"
    return false unless /^[rnbqkp][a-h][1-8]/ =~ usersMove
    return true
  end

  
  # must be a promotion
  def validLengthFour? usersMove
    return false unless /^[a-h][81]=[rnbq]/ =~ usersMove
    return true
  end

  # must be two pieces able to move to square or promotion
  def validLengthFive? usersMove
    if (not /^p[abcedfgh][81]=[rnbq]/ =~ usersMove) &&
       (not /^[rnbq][a-h][1-8][a-h][1-8]/ =~ usersMove)
      return false
    else
      return true
    end
  end

end
