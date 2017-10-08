require "~/the_odin_project/ruby_exercises/chess/lib/board.rb"
class Chess

  attr_accessor :board

  def initialize
    @board = Board.new
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
    validMove? usersMove
  end

  # Cases for valid moves
  # Typical moving of a piece: Nd5 , Pe4, Qd6
  # Pawn moves: e5, a5
  # Capturing pieces: Nxe4
  # Castling: O-O-O , O-O
  # Promotion: e8=Q , b1=N
  # checks: Bb5+
  # Two of same piece can move to square: Nb4-d3
  # enpassant : exd5  
  def validMove? usersMove
    # get rid of some symbols that are common convention when entering moves
    usersMove = usersMove.downcase.gsub("x","").gsub("-","").gsub("+","")
    #possible first letters

    case usersMove.length
    when 2 #must be a pawn move or short castle
      return true if usersMove == "oo"
      return false unless /^[a-h][1-8]/ =~ usersMove
      return true

    when 3 #standard move or long caslte or pawn capture
      return true if /[a-h][a-h][1-8]/ =~ usersMove
      return true if usersMove == "ooo"
      return false unless /^[rnbqkp][a-h][1-8]/ =~ usersMove
      return true

    when 4 # must be a promotion
      return false unless /^[a-h][81]=[rnbq]/ =~ usersMove
      return true

    when 5 # must be two pieces able to move to square or promotion

      if (not /^p[abcedfgh][81]=[rnbq]/ =~ usersMove) &&
         (not /^[rnbq][a-h][1-8][a-h][1-8]/ =~ usersMove)
        return false
      else
        return true
      end
    else 
      return false
    end
  end

  def whosTurn
    if @ply % 2 == 0 then return "White"
    else return "Black"
    end
  end


end
