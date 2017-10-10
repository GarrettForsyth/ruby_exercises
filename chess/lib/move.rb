class Move

  attr_accessor :piece, :to, :from

  def initialize(piece, to, from=nil)
    @piece = piece
    @to = to
    @from = from
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
    [@piece, @to, @from]
  end


end
