class Move

  attr_accessor :piece, :to, :from

  def initialize(piece, to, from=nil)
    @piece = piece
    @to = to
    @from = from
  end
end
