require "./board.rb"
require "./chess_rules.rb"

q = Queen.new(:white)
p = Pawn.new(:white)
n = Knight.new(:white)
k = King.new(:black)

b = Board.new
r= ChessRules.new

b.setSquare("e1", q)
b.setSquare("a2", p)
b.setSquare("b3", p)
b.setSquare("b1", n)
b.setSquare("e8", k)

m = Move.new(b, q, "e8")
m2 = Move.new(b, p, "a3")
m3 = Move.new(b, n, "c3")

puts "valid queen move." if r.isValidQueenMove? m
puts "legal queen move."  if  r.isLegalMove? m

puts "valid pawn move." if r.isValidPawnMove? m2
puts "legal pawn move."  if  r.isLegalMove? m2

puts "valid knight move." if r.isValidKnightMove? m3
puts "legal Knight move."  if  r.isLegalMove? m3

puts "queen attacks e8" if r.isSquareAttackedBy?("e8", :white, b)
puts b.getCoordOf(Pawn.new(:white))

puts "black is in check" if r.isInCheck?(:black, b)
puts "queen attacks e8" if r.isSquareAttackedBy?("e8", :white, b)
