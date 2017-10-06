class Chess

  attr_accessor :board, :pieces

  def initialize
    @board = Board.new
    @pieces = []
    createPieces
  end

  def startGame
    placePiecesAtStartingPositions
    draw
  end

  def createPieces
    createPieceSetFor :white
    createPieceSetFor :black
  end

  def createPieceSetFor colour
    create(8, Pawn, colour)
    create(2, Rook, colour)
    create(2, Knight, colour)
    create(2, Bishop, colour)
    create(1, Queen, colour)
    create(1, King, colour)
  end

  def create(number, pieceType, colour)
    for i in 0...number do
      @pieces << pieceType.new(colour)
    end
  end

  def placePiecesAtStartingPositions
    placeWhitePieces
    placeBlackPieces
  end

  def placeWhitePieces
    placeWhitePawns
    setSquare("a1", @pieces[8])
    setSquare("h1", @pieces[9])
    setSquare("b1", @pieces[10])
    setSquare("g1", @pieces[11])
    setSquare("c1", @pieces[12])
    setSquare("f1", @pieces[13])
    setSquare("d1", @pieces[14])
    setSquare("e1", @pieces[15])
  end

  def placeBlackPieces
    placeBlackPawns
    setSquare("a8", @pieces[24])
    setSquare("h8", @pieces[25])
    setSquare("b8", @pieces[26])
    setSquare("g8", @pieces[27])
    setSquare("c8", @pieces[28])
    setSquare("f8", @pieces[29])
    setSquare("d8", @pieces[30])
    setSquare("e8", @pieces[31])
  end

  def placeWhitePawns
    col = "a"
    for i in 0...8 do
      coord =  "#{col}2"
      puts coord
      setSquare(coord,@pieces[i])
      col = col.next
    end
  end

  def placeBlackPawns
    col = "a"
    for i in 0...8 do
      coord =  "#{col}7"
      setSquare(coord,@pieces[i+16])
      col = col.next
    end
  end
  
  def getSquare(coordiante)
    @board.getSquare(coordiante)
  end

  def setSquare(coordiante, piece)
    @board.setSquare(coordiante,piece)
  end

  def draw
    @board.draw
  end

end

class Board

  NUMBER_OF_COLUMNS = 8
  NUMBER_OF_ROWS = 8
  attr_accessor :squares

  # Each square object should have it's own reference
  def initialize
    @squares = []
    for i in 0...64 do
       @squares[i] = Square.new 
    end
  end

  def getSquare(coordiante)
    index = parse(coordiante)
    @squares[index]
  end

  def setSquare(coordiante, piece)
    index = parse(coordiante)
    @squares[index].occupancy = piece
  end

  def parse(coordiante)
   col = coordiante[0].ord - 97
   row = coordiante[1].to_i - 1
   col + row*NUMBER_OF_COLUMNS 
  end

  def draw
    for i in 7.downto(0) do
      drawBar
      drawRow i
    end
    drawBar
  end

  def drawBar
   33.times {print "-"}
    puts ""
  end

  def drawRow rowNum
    start = rowNum * NUMBER_OF_ROWS
    fin = start + NUMBER_OF_COLUMNS 
    for i in start...fin do
      print "| #{@squares[i].draw} "
    end
    puts "|"
  end
  
end

class Square
  
  attr_accessor :occupied, :occupancy

  def initialize occupied=false
    @occupied = occupied
    @occupancy
  end

  def occupied?
    !@occupancy.nil?
  end

  def occupiedBy
    @occupancy
  end

  def draw
    if occupied? then return @occupancy.draw
    else return " "
    end
  end

end

class Piece

  attr_accessor :colour

  def initialize colour
    @colour = colour  
  end

end

class Pawn < Piece
  def draw
    if @colour == :white
      return "♙"
    else
      return "♟" 
    end
  end
end

class Rook < Piece
    def draw
      if @colour == :black then return "♖"
      else return "♜" 
      end
    end
end

class Knight < Piece
  def draw
    if @colour == :black then return "♘"
    else return "♞" 
    end
  end
end

class Bishop < Piece
  def draw                           
    if @colour == :black then return "♗"
    else return "♝" 
    end
  end
end

class Queen < Piece
  def draw                           
    if @colour == :black then return "♕"
    else return "♛" 
    end
  end
end 

class King < Piece
  def draw                           
    if @colour == :black then return "♔"
    else return "♚" 
    end
  end
end
