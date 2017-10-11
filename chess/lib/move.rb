class Move

  attr_accessor :piece, :to, :from, :board

  def initialize(board, piece, to, from=nil)
    @piece = piece
    @to = to
    @from = from
    @board = board
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
    [@board, @piece, @to, @from]
  end


end
