require "../lib/chess.rb"

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

    it "creates 32 pieces" do
      expect(game.pieces.length).to eq 32
    end

    it "creates 16 pieces of each colour" do
      whiteCount = 0
      blackCount = 0
      for i in 0...32 do
        whiteCount+=1 if game.pieces[i].colour == :white
        blackCount+=1 if game.pieces[i].colour == :black
      end
      expect(whiteCount).to eq 16
      expect(blackCount).to eq 16
    end

    it "creates the correct # of pieces for each colour" do
      def countPieces(piece, expectedCount)
        whiteCount = 0
        blackCount = 0
        for i in 0...32 do
          p = game.pieces[i]
          whiteCount += 1 if p.instance_of?(piece) && p.colour == :white
          blackCount += 1 if p.instance_of?(piece) && p.colour == :black
        end
        expect(whiteCount).to eq expectedCount
        expect(blackCount).to eq expectedCount
      end

      countPieces(Pawn, 8)
      countPieces(Rook,2)
      countPieces(Knight,2)
      countPieces(Bishop,2)
      countPieces(Queen,1)
      countPieces(King,1)
    end
  end

  describe "#startGame" do

    it "places the pieces on their proper starting positions" do
      game.startGame
      expect(game.getSquare("a2").occupiedBy).to be_an_instance_of Pawn
      expect(game.getSquare("a2").occupiedBy.colour).to eq :white
    end

    it "draws the board" do
      expect(game).to receive(:drawBoard)
      game.startGame
    end

    it "prompts the user for a move" do
      expect(game).to receive(:promptMove)
      game.startGame
    end

  end

end

describe Board do
  let(:board) { Board.new }

  it "has 64 squares" do
    expect(board.squares.length).to eq 64
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
