require "./lib/connect4.rb"

game = Connect4.new

game.startGame
5.times {game.updateBoard "0"
puts "last move was #{game.last_move[0]} , #{game.last_move[1]}"}
