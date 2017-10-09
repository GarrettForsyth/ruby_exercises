class Piece

  attr_accessor :colour

  def initialize colour
    @colour = colour  
  end

end

class Pawn < Piece

  attr_accessor :firstMove

  def initialize colour, firstMove=false
    @firstMove = firstMove
    super(colour)
  end

  def draw
    if @colour == :black
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
