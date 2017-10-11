class Piece

  attr_accessor :colour, :firstMove

  def initialize colour, firstMove=false
    @colour = colour  
    @firstMove = firstMove
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def eql?(o)
    return self==(o)
  end

  def hash
    state.hash
  end

  protected
  
  def state 
    [@colour]
  end

end

class Pawn < Piece

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
