require "../lib/chess.rb"
require "../lib/board.rb"
require "../lib/move_parser.rb"
require "../lib/move.rb"

describe Chess do
  let(:game){ Chess.new }

  # Redirect std outputs to text files
  # Alternatively this could be directed to a local
  # text file if the output was thought to be useful
  RSpec.configure do |config|
    original_stderr = $stderr
    original_stdout = $stdout
    config.before(:all) do
      $stderr = File.open(File::NULL, "w")
      $stdout = File.open(File::NULL, "w")
    end
    config.after(:all) do
      $stderr = original_stderr
      $stdout = original_stdout
    end
  end

  describe "creating a new game of chess" do
    describe "#new" do
      it "creates a new Chess instance" do
        expect(game).to be_an_instance_of(Chess)
      end
    end

    it "it creates a chess board" do
      expect(game.board).to be_an_instance_of(Board)
    end

    it "has a set of rules" do
      expect(game.rules).to be_an_instance_of(ChessRules)
    end
  end

  describe "#startGame" do

    it "draws the board" do
      expect(game).to receive(:drawBoard)
      game.startGame
    end

    it "prompts the user for a move" do
      expect(game).to receive(:promptMove)
      game.startGame
    end
  end

  describe "#promptMove" do
    it "prompts the user to enter a move" do
      prompt = "White's move: "
      allow(game).to receive(:gets) { "e4" }
      expect{ game.promptMove }.to output(prompt).to_stdout
    end

    it "gets the users response" do
      allow(game).to receive(:gets) { "e4" }
      expect(game).to receive(:gets)
      game.promptMove
    end

    xit "validates the users response" do
      expect(game).to receive(:validMove?)
      game.promptMove
    end
  end

end

describe Board do
  let(:board) { Board.new }

  it "has 64 squares" do
    expect(board.squares.length).to eq 64
  end

  describe "#setStaringPosition" do
    it "creates 32 pieces" do
      board.setStartingPosition
      expect(board.pieces.leaves.length).to eq 32
    end

    it "creates 16 pieces of each colour" do
      board.setStartingPosition
      expect(board.pieces[:white].leaves.length).to eq 16
      expect(board.pieces[:black].leaves.length).to eq 16
    end
                                                                         
  end

  it "places the pieces on their proper starting positions" do
    board.setPiecesAtStartingPositions
    expect(board.getSquare("a2").occupiedBy).to be_an_instance_of Pawn
    expect(board.getSquare("a2").occupiedBy.colour).to eq :white
  end

  describe "#unParseToCoord" do
    context "the numbers from 0 to 64 to their board coordinates" do
      it " maps 0 to a1" do
        expect(board.unParseToCoord(0)).to eq "a1"
      end

      it "maps 63 to h8" do
        expect(board.unParseToCoord(63)).to eq "h8"
      end

      it "maps 36 to e4" do
        expect(board.unParseToCoord(36)).to eq "e5"
      end

      it "maps 56 to a8" do
        expect(board.unParseToCoord(56)).to eq "a8"
      end


      it "maps 7 to h1" do
        expect(board.unParseToCoord(7)).to eq "h1"

      end
    end
  end

  describe "#getSquaresInBetween" do
    it "returns an array of squares between a1 and a8" do
      expecetdSquares = ["a2","a3","a4","a5","a6","a7","a8"]
      expect(board.getSquaresInbetween("a1","a8")).to eq expecetdSquares
    end

    it "returns an array of squares between a8 and a1" do
      expecetdSquares = ["a7","a6","a5","a4","a3","a2","a1"]
      expect(board.getSquaresInbetween("a8","a1")).to eq expecetdSquares
    end


    it "return sn array of squares between a1 and h1" do
      expecetdSquares = ["b1","c1","d1","e1","f1","g1","h1"]
      expect(board.getSquaresInbetween("a1","h1")).to eq expecetdSquares
    end

    it "returns an array of squares between h1 and a1" do
      expecetdSquares = ["g1","f1","e1","d1","c1","b1","a1"]             
      expect(board.getSquaresInbetween("h1","a1")).to eq expecetdSquares
    end

    it "returns an array of squares between a1 and h8" do
      expecetdSquares = ["b2","c3","d4","e5","f6","g7","h8"]             
      expect(board.getSquaresInbetween("a1","h8")).to eq expecetdSquares
    end

    it "returns an array of squares between h8 and a1" do
      expecetdSquares = ["g7","f6","e5","d4","c3","b2","a1"]             
      expect(board.getSquaresInbetween("h8","a1")).to eq expecetdSquares
    end

    it "returns an array with squares between h1 and a8" do
      expecetdSquares = ["g2","f3","e4","d5","c6","b7","a8"]             
      expect(board.getSquaresInbetween("h1","a8")).to eq expecetdSquares
    end

    it "returns array of squares between a8 and h1" do
      expecetdSquares = ["b7","c6","d5","e4","f3","g2","h1"]              
      expect(board.getSquaresInbetween("a8","h1")).to eq expecetdSquares
    end
  end
end

describe Square do
  let(:square) { Square.new }
  context "when it is occupied by a piece" do
    it "returns true when asked if occupied" do
      square.occupancy = Pawn.new :white
      expect(square.occupied?).to eq true
    end
  end
  context "when it is not occupied by a piece" do
    it "it returns false when asked if occupied" do
      expect(square.occupied?).to eq false
    end
  end
end

describe Piece do
  let(:piece){ Piece.new :white }

  it "should belong to a colour/player" do
    expect(piece.colour).to eq :white
  end

end

describe ChessRules do
  let(:rules) { ChessRules.new }
  let(:board) { Board.new      }

  describe "#isValidPawnMove?" do
    it "returns true when pawns move foward to unoccupied square" do
      board.setSquare("a2", Pawn.new(:white))
      expect(rules.isValidPawnMove?(Move.new "a4", board)).to eq true
    end
  end
end

describe Move do
  let(:move) { Move.new(:Knight, "e4", "c3") }

  it " has an attribute that stores the piece " do
    expect(move.piece).to eq :Knight
  end

  it " has an attibute that stores the square the piece came from" do
    expect(move.from).to eq "c3"
  end

  it "has an attribute that stores where the piece is going to" do
    expect(move.to).to eq "e4"
  end
end

describe MoveParser do
  let (:parser) { MoveParser.new}

  describe "#validMoveFormat?" do                                              
    context "when given a valid move" do
      it "returns true on a normal move" do
        expect(parser.validMoveFormat?("Ne3")).to eq true
      end
                                                                         
      it "returns true on a pawn move" do
        expect(parser.validMoveFormat?("e4")).to eq true
        expect(parser.validMoveFormat?("Pe3")).to eq true
      end
                                                                         
      it "return true on a check" do
        expect(parser.validMoveFormat?("e4+")).to eq true
        expect(parser.validMoveFormat?("Bb4+")).to eq true
      end
                                                                         
      it "returns ture on castling" do
        expect(parser.validMoveFormat?("o-o")).to eq true
        expect(parser.validMoveFormat?("o-o-o")).to eq true
      end
                                                                         
      it "returns true on pawn captures" do
        expect(parser.validMoveFormat?("exd4")).to eq true
      end
                                                                         
      it "returns true on promotions" do
        expect(parser.validMoveFormat?("a8=Q")).to eq true
        expect(parser.validMoveFormat?("Ph1=N")).to eq true
      end
                                                                         
      it "returns true when two of the same piece can go to a square" do
        expect(parser.validMoveFormat?("Nd5-e3")).to eq true
      end
    end
                                                                         
    context "when given an invalid move" do
      it " returns on first invalid first character" do
        expect(parser.validMoveFormat?("Zd4-e3")).to eq false
      end
                                                                         
      it " return false on move too far right" do
        expect(parser.validMoveFormat?("Ni5")).to eq false
      end
                                                                         
      it " returns false on a move too far up" do
        expect(parser.validMoveFormat?("Na9")).to eq false
      end
                                                                         
      it " returns false on gibberish" do
        expect(parser.validMoveFormat?("iakjdlsfl;k")).to eq false
      end
                                                                         
      it " returns false on empty input" do
        expect(parser.validMoveFormat?("")).to eq false
      end
                                                                         
      it " returns false with two pawn moves entered" do
        expect(parser.validMoveFormat?("e4e4")).to eq false
                                                                         
      end
    end
  end
end

class Hash
  # counts the leaves in the nested hash (counts pieces in piece hash)
  def leaves
    leaves = []
    each_value do |val|
      val.is_a?(Hash) ? val.leaves.each{|l| leaves << l } : leaves << val
    end
    leaves
  end
end


