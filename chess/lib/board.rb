# This class models a chess board. It can be initalized to a position
# by passing a hash mapping pieces to squares, otherwise, it defaults
# to an empty board.
#
# To get a board with the pieces in the starting position, call #setStartingPosition

require "~/the_odin_project/ruby_exercises/chess/lib/piece.rb"
require "~/the_odin_project/ruby_exercises/chess/lib/chess_rules.rb"
class Board

  NUMBER_OF_COLUMNS = 8
  NUMBER_OF_ROWS = 8
  attr_accessor :squares, :pieces

  # Each square object should have it's own reference
  # New board is initialized with 
  def initialize pieces=nil
    @squares = []
    for i in 0...64 do
       @squares[i] = Square.new 
    end

    @pieces = pieces
    @pieces ||= createPieceHash
    @rules = ChessRules.new
  end

  def createPieceHash
    @pieces = {  white: { 
                         Pawn: {},
                         Knight: {}, 
                         Bishop: {},
                         Rook: {}, 
                         Queen: {}, 
                         King: {}
                        },

                 black: {              
                          Pawn: {},
                          Knight: {}, 
                          Bishop: {},
                          Rook: {}, 
                          Queen: {}, 
                          King: {}
                         }
              }
  end

  def setStartingPosition
    setPiecesAtStartingPositions
  end

  def getSquare(coordiante)
    index = parse(coordiante)
    @squares[index]
  end

  def getPieceAt(coordiante)
    getSquare(coordiante).occupancy
  end

  def setSquare(coord, piece)
    index = parse(coord)
    @squares[index].occupancy = piece
    @pieces[piece.colour][piece.class.to_s.to_sym][coord] ||= 
      piece  unless piece.nil?
  end

  def parse(coordiante)
   col = coordiante[0].ord - 97
   row = coordiante[1].to_i - 1
   col + row*NUMBER_OF_COLUMNS 
  end
  
  def unParseToCoord(squareNum)
    num = squareNum/8 + 1
    let = ((squareNum % 8)+97).chr
    return let + num.to_s
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

  def createPiece(colour, pieceType, coord)
    @pieces[colour]
  end

  def setPiece(colour, pieceType, coord)
    newPiece = pieceType.new(colour,true)
    setSquare(coord, newPiece)
  end

  def setPiecesAtStartingPositions
    setUpWhiteStartingPieces
    setUpBlackStartingPieces
  end
                                        
  def setUpWhiteStartingPieces
    setWhiteStartingPawns
    setPiece(:white, Rook,   "a1")
    setPiece(:white, Rook,   "h1")
    setPiece(:white, Knight, "b1")
    setPiece(:white, Knight, "g1")
    setPiece(:white, Bishop, "c1")
    setPiece(:white, Bishop, "f1")
    setPiece(:white, Queen,  "d1")
    setPiece(:white, King,   "e1")
  end
                                        
  def setUpBlackStartingPieces
    setBlackStartingPawns
    setPiece(:black, Rook,   "a8")
    setPiece(:black, Rook,   "h8")
    setPiece(:black, Knight, "b8")
    setPiece(:black, Knight, "g8")
    setPiece(:black, Bishop, "c8")
    setPiece(:black, Bishop, "f8")
    setPiece(:black, Queen,  "d8")
    setPiece(:black, King,   "e8")
  end
                                        
  def setWhiteStartingPawns
    col = "a"
    for i in 0...8 do
      coord =  "#{col}2"
      setPiece(:white, Pawn, coord)
      col = col.next
    end
  end
                                        
  def setBlackStartingPawns
    col = "a"
    for i in 0...8 do
      coord =  "#{col}7"
      setPiece(:black, Pawn, coord)
      col = col.next
    end
  end

  # Gets the coordinates of the squares between (coord1, coord2]
  def getSquaresInbetween(coord1, coord2)
    if coord1[0] == coord2[0] # same column
      return getSquaresInbetweenColumn(coord1,coord2)

    elsif coord1[1] == coord2[1] # same row
      return getSquaresInbetweenRow(coord1,coord2)

    # if the slope of the squres is +1 --> positive diagonal
    elsif ((coord2[0].ord-coord1[0].ord)) == (coord2[1].to_i-coord1[1].to_i)
      return getSquaresInbeteweenPositiveDiagonal(coord1,coord2)

    # if the slope of the squres is -1 --> positive diagonal
    elsif ((coord2[0].ord-coord1[0].ord)) == -(coord2[1].to_i-coord1[1].to_i)
      return getSquaresInbeteweenNegativeDiagonal(coord1,coord2)
    end
  end

  def getSquaresInbetweenColumn(coord1,coord2)
    squares = []
    c1 = parse(coord1)
    c2 = parse(coord2)
    # moving 'up' the board
    if c2 > c1 
      (c1+8).step(c2-8,8) { |i|squares << unParseToCoord(i) }
      return squares
    # moving 'down' the board 
    else
      # -8 to disclude the first square (that the piece is on)
      (c1-8).step(c2+8, -8) { |i|squares << unParseToCoord(i) }
      return squares
    end
  end

  def getSquaresInbetweenRow(coord1,coord2)
    squares = []
    c1 = parse(coord1)
    c2 = parse(coord2)

    if c2 > c1 
      (c1+1).step(c2-1,1) { |i|squares << unParseToCoord(i) }
      return squares
    else
      (c1-1).step(c2+1,-1) { |i| squares << unParseToCoord(i) }
      return squares
    end
  end

  def getSquaresInbeteweenPositiveDiagonal(coord1,coord2)
    squares = []
    c1 = parse(coord1)
    c2 = parse(coord2)

    if c2 > c1
      (c1+9).step(c2-9,9) {|i| squares << unParseToCoord(i) } 
      return squares
    else
      (c1-9).step(c2+9,-9) {|i| squares << unParseToCoord(i) }
      return squares
    end
  end

  def getSquaresInbeteweenNegativeDiagonal(coord1, coord2)
    squares = []
    c1 = parse(coord1)
    c2 = parse(coord2)
                                                             
    if c2 > c1
      (c1+7).step(c2-7,7) {|i| squares << unParseToCoord(i) } 
      return squares
    else
      (c1-7).step(c2+7,-7) {|i| squares << unParseToCoord(i) }
      return squares
    end
  end

  # Returns an array of the coordinates that match piece
  def getCoordOf(piece)
    coords = []
    @pieces[piece.colour][piece.class.to_s.to_sym].each do |coord, piece|
      coords << coord
    end
    return coords
  end

  # returns new instance of board reflecting users move
  def move(move)

    
    
    
    

    if @rules.isCastleShort?(move)
      if move.piece.colour == :white
        r = "h1" ; r2 = "f1";
      else
        r = "h8"; r2= "f8";
      end
      m = Move.new(self, self.getSquare(r).occupancy, r2, r)
      self.move(m)
    elsif @rules.isCastleLong?(move)
      if move.piece.colour == :white
        r = "a1" ; r2 = "d1";
      else
        r = "a8"; r2= "d8";
      end
      m = Move.new(self, self.getSquare(r).occupancy, r2, r)
      self.move(m)
    end

    @pieces[move.piece.colour][move.piece.class.to_s.to_sym].delete(move.from)
    setSquare(move.from, nil)
    move.piece.firstMove = false
    setSquare(move.to, move.piece)

    return self
  end

  def==(o)
    o.class == self.class && o.state == state
  end

  def eql?(o)
    return self==o
  end

  def hash
    state.hash
  end

  protected

  def state
    [@squares, @pieces]
  end

end

# This class models a single square ona  chess board
class Square
  
  attr_accessor  :occupancy

  def initialize 
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

  def ==(o)
    o.class == self.class && o.state == self.state
  end

  def eql?(o)
    return self==o
  end

  def hash
    state.hash
  end

  protected

  def state
    [@occupancy]
  end

end










