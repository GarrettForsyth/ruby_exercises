require "../lib/chess.rb"
require "../lib/board.rb"

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

    it "validates the users response" do
      expect(game).to receive(:validMove?)
      game.promptMove
    end
  end

  describe "#validMove?" do
    context "when given a valid move" do
      it "returns true on a normal move" do
        expect(game.validMove?("Ne4")).to eq true
      end

      it "returns true on a pawn move" do
        expect(game.validMove?("e4")).to eq true
        expect(game.validMove?("Pe4")).to eq true
      end

      it "return true on a check" do
        expect(game.validMove?("e4+")).to eq true
        expect(game.validMove?("Bb4+")).to eq true
      end

      it "returns ture on castling" do
        expect(game.validMove?("o-o")).to eq true
        expect(game.validMove?("o-o-o")).to eq true
      end

      it "returns true on pawn captures" do
        expect(game.validMove?("exd5")).to eq true
      end

      it "returns true on promotions" do
        expect(game.validMove?("a8=Q")).to eq true
        expect(game.validMove?("Ph1=N")).to eq true
      end

      it "returns true when two of the same piece can go to a square" do
        expect(game.validMove?("Nd5-e3")).to eq true
      end
    end

    context "when given an invalid move" do
      it " returns on first invalid first character" do
        expect(game.validMove?("Zd5-e3")).to eq false
      end

      it " return false on move too far right" do
        expect(game.validMove?("Ni5")).to eq false
      end

      it " returns false on a move too far up" do
        expect(game.validMove?("Na9")).to eq false
      end

      it " returns false on gibberish" do
        expect(game.validMove?("iakjdlsfl;k")).to eq false
      end

      it " returns false on empty input" do
        expect(game.validMove?("")).to eq false
      end

      it " returns false with two pawn moves entered" do
        expect(game.validMove?("e4e4")).to eq false

      end
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
