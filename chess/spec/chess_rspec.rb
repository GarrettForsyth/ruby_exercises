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
      expecetdSquares = ["a2","a3","a4","a5","a6","a7",]
      expect(board.getSquaresInbetween("a1","a8")).to eq expecetdSquares
    end

    it "returns an array of squares between a8 and a1" do
      expecetdSquares = ["a7","a6","a5","a4","a3","a2",]
      expect(board.getSquaresInbetween("a8","a1")).to eq expecetdSquares
    end


    it "return sn array of squares between a1 and h1" do
      expecetdSquares = ["b1","c1","d1","e1","f1","g1",]
      expect(board.getSquaresInbetween("a1","h1")).to eq expecetdSquares
    end

    it "returns an array of squares between h1 and a1" do
      expecetdSquares = ["g1","f1","e1","d1","c1","b1",]             
      expect(board.getSquaresInbetween("h1","a1")).to eq expecetdSquares
    end

    it "returns an array of squares between a1 and h8" do
      expecetdSquares = ["b2","c3","d4","e5","f6","g7",]             
      expect(board.getSquaresInbetween("a1","h8")).to eq expecetdSquares
    end

    it "returns an array of squares between h8 and a1" do
      expecetdSquares = ["g7","f6","e5","d4","c3","b2",]             
      expect(board.getSquaresInbetween("h8","a1")).to eq expecetdSquares
    end

    it "returns an array with squares between h1 and a8" do
      expecetdSquares = ["g2","f3","e4","d5","c6","b7",]             
      expect(board.getSquaresInbetween("h1","a8")).to eq expecetdSquares
    end

    it "returns array of squares between a8 and h1" do
      expecetdSquares = ["b7","c6","d5","e4","f3","g2",]              
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
    it "returns true when white pawns move foward one to unoccupied square" do
      board.setSquare("a2", Pawn.new(:white))
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a3","a2")
                                             )).to eq true
    end

    it "returns true when black pawns move foward one to unoccupied square" do
      board.setSquare("a7", Pawn.new(:black))
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a6","a7")
                                             )).to eq true
    end

    it "returns false when white pawns move back one to unoccupied square" do
      board.setSquare("a4", Pawn.new(:white))
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a3","a4")
                                             )).to eq false
    end

    it "returns false when black pawns move back one to unoccupied square" do
      board.setSquare("a5", Pawn.new(:black))
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a6","a5")
                                             )).to eq false
    end

    it "returns false when white pawns move foward one to occupied square" do  
      board.setSquare("a3", Pawn.new(:black))
      board.setSquare("a2", Pawn.new(:white))
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a3","a2")
                                             )).to eq false
    end

    it "returns false when black pawns foward one to occupied square" do  
      board.setSquare("a6", Pawn.new(:black))                                   
      board.setSquare("a7", Pawn.new(:black))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a6","a7")
                                             )).to eq false
    end

    it "returns false when black pawns foward 2+ squares" do  
      board.setSquare("a6", Pawn.new(:black))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a2","a6")
                                             )).to eq false
    end

    it "returns false when white pawns foward 2+ squares" do  
      board.setSquare("a2", Pawn.new(:white))                                   
    expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a6","a2") 
                                             )).to eq false
    end

    it "returns true when white pawns foward 2 squares on first move" do  
      board.setSquare("a2", Pawn.new(:white,true))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white,true),"a4","a2")
                                             )).to eq true
    end

    it "returns true when black pawns foward 2 squares on first move" do  
      board.setSquare("a7", Pawn.new(:black,true))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black,true),"a5","a7") 
                                             )).to eq true
    end

    it "returns false when white pawns foward 2 squares on not first move" do         
      board.setSquare("a3", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a5","a3")
                                             )).to eq false
    end

    it "returns false when black pawns foward 2 squares on not first move" do  
      board.setSquare("a6", Pawn.new(:black))                                   
    expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a4","a6")
                                             )).to eq false
    end

    it "returns false when white pawns foward 2 squares through a piece" do  
      board.setSquare("a3", Pawn.new(:white))                                   
      board.setSquare("a2", Pawn.new(:white))                                   
    expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a4","a2") 
                                             )).to eq false
    end

    it "returns false when black pawns foward 2 squares through a piece" do  
      board.setSquare("a7", Pawn.new(:black))                                   
      board.setSquare("a6", Pawn.new(:white))                                   
    expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a5","a7") 
                                             )).to eq false
    end                                                            

    it "returns true if one move foward diagonally pos for a capture" do
      board.setSquare("a2", Pawn.new(:white))                                   
      board.setSquare("b3", Pawn.new(:black))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"b3","a2") 
                                             )).to eq true
    end

    it "returns true if one move foward diagonally neg for a capture" do
      board.setSquare("a3", Pawn.new(:black))                                   
      board.setSquare("b2", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a3","b2")
                                             )).to eq true
    end

    it "returns false if one move foward diagonally neg for a non capture" do
      board.setSquare("b2", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a3","b2")
                                             )).to eq false
    end

    it "returns true if one move foward diagonally pos for a capture for black" do
      board.setSquare("a6", Pawn.new(:white))                                   
      board.setSquare("b7", Pawn.new(:black))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"a6","b7") 
                                             )).to eq true
    end
                                                                                 
    it "returns true if one move foward diagonally neg for a capture for black" do
      board.setSquare("a7", Pawn.new(:black))                                   
      board.setSquare("b6", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"b6","a7")
                                             )).to eq true
    end
                                                                                 
    it "returns false if one move foward diagonally neg for a non capture for black" do
      board.setSquare("b7", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"a6","b7") 
                                             )).to eq false
    end

    it "returns false if white tries to capture own piece" do 
      board.setSquare("b2", Pawn.new(:white))                                   
      board.setSquare("c3", Pawn.new(:white))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:white),"c3","b2")
                                             )).to eq false
    end

    it "returns false if black tries to capture own piece " do
      board.setSquare("b7", Pawn.new(:black))                                   
      board.setSquare("c6", Pawn.new(:black))                                   
      expect(rules.isValidPawnMove?(Move.new(board, Pawn.new(:black),"c6","b7")
                                             )).to eq false
    end

  end


  describe "#isValidRookMove?" do
    it "returns true when rook moves in a row" do
      board.setSquare("e1", Rook.new(:white))
      board.setSquare("e8", Rook.new(:black))
      m1 = Move.new(board, board.getPieceAt("e1"), "a1", "e1")
      m2 = Move.new(board, board.getPieceAt("e1"), "h1", "e1")
      m3 = Move.new(board, board.getPieceAt("e8"), "h8", "e8")
      m4 = Move.new(board, board.getPieceAt("e8"), "a8", "e8")

      expect(rules.isValidRookMove?(m1)).to eq true
      expect(rules.isValidRookMove?(m2)).to eq true
      expect(rules.isValidRookMove?(m3)).to eq true
      expect(rules.isValidRookMove?(m4)).to eq true
    end

    it "returns true when rook moves in column" do
      board.setSquare("e4", Rook.new(:white))
      board.setSquare("d5", Rook.new(:black))
      m1 = Move.new(board, board.getPieceAt("e4"), "e1", "e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "e8", "e4")
      m3 = Move.new(board, board.getPieceAt("d5"), "d1", "d5")
      m4 = Move.new(board, board.getPieceAt("d5"), "d8", "d5")
                                                          
      expect(rules.isValidRookMove?(m1)).to eq true
      expect(rules.isValidRookMove?(m2)).to eq true
      expect(rules.isValidRookMove?(m3)).to eq true
      expect(rules.isValidRookMove?(m4)).to eq true
    end

    it "returns false when the rook moves in a diagonal" do
      board.setSquare("e4", Rook.new(:white))
      board.setSquare("d5", Rook.new(:black))
      m1 = Move.new(board, board.getPieceAt("e4"), "h1", "e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "a8", "e4")
      m3 = Move.new(board, board.getPieceAt("d5"), "a1", "d5")
      m4 = Move.new(board, board.getPieceAt("d5"), "h8", "d5")
                                                          
      expect(rules.isValidRookMove?(m1)).to eq false
      expect(rules.isValidRookMove?(m2)).to eq false
      expect(rules.isValidRookMove?(m3)).to eq false
      expect(rules.isValidRookMove?(m4)).to eq false
    end

    context "returns false when rook moves through a piece" do
      it " on horizontal rook moves" do
        board.setSquare("e1", Rook.new(:white))
        board.setSquare("e8", Rook.new(:black))


        board.setSquare("c8", Bishop.new(:white))
        board.setSquare("f8", Bishop.new(:black))
        board.setSquare("c1", Bishop.new(:white))
        board.setSquare("f1", Bishop.new(:black))
        m1 = Move.new(board, board.getPieceAt("e1"), "a1", "e1")
        m2 = Move.new(board, board.getPieceAt("e1"), "h1", "e1")
        m3 = Move.new(board, board.getPieceAt("e8"), "h8", "e8")
        m4 = Move.new(board, board.getPieceAt("e8"), "a8", "e8")
                                                             
        expect(rules.isValidRookMove?(m1)).to eq false
        expect(rules.isValidRookMove?(m2)).to eq false
        expect(rules.isValidRookMove?(m3)).to eq false
        expect(rules.isValidRookMove?(m4)).to eq false
      end

      it " for vertical rook moves" do
        board.setSquare("e4", Rook.new(:white))
        board.setSquare("d5", Rook.new(:black))

        board.setSquare("d3", Knight.new(:black))
        board.setSquare("d6", Knight.new(:white))
        board.setSquare("e6", Knight.new(:white))
        board.setSquare("e3", Knight.new(:black))
        m1 = Move.new(board, board.getPieceAt("e4"), "e1", "e4")
        m2 = Move.new(board, board.getPieceAt("e4"), "e8", "e4")
        m3 = Move.new(board, board.getPieceAt("d5"), "d1", "d5")
        m4 = Move.new(board, board.getPieceAt("d5"), "d8", "d5")
                                                            
        expect(rules.isValidRookMove?(m1)).to eq false
        expect(rules.isValidRookMove?(m2)).to eq false
      end

      it "returns true when taking horizontally" do
        board.setSquare("a1", Rook.new(:white))              
        board.setSquare("h1", Rook.new(:black))
        m1 = Move.new(board, board.getPieceAt("a1"), "h1", "a1")
        m2 = Move.new(board, board.getPieceAt("h1"), "a1", "h1")
                                                             
        expect(rules.isValidRookMove?(m1)).to eq true
        expect(rules.isValidRookMove?(m2)).to eq true
      end

      it "returns true when taking vertically" do
        board.setSquare("d8", Rook.new(:white))              
        board.setSquare("d1", Rook.new(:black))
        m1 = Move.new(board, board.getPieceAt("d8"), "d1", "d8")
        m2 = Move.new(board, board.getPieceAt("d1"), "d8", "d1")
                                                             
        expect(rules.isValidRookMove?(m1)).to eq true
        expect(rules.isValidRookMove?(m2)).to eq true
      end

      it "returns false when taking own piece horizontally" do
        board.setSquare("a1", Rook.new(:white))              
        board.setSquare("h1", Rook.new(:white))
        m1 = Move.new(board, board.getPieceAt("a1"), "h1", "a1")
        m2 = Move.new(board, board.getPieceAt("h1"), "a1", "h1")
                                                             
        expect(rules.isValidRookMove?(m1)).to eq false
        expect(rules.isValidRookMove?(m2)).to eq false
      end

      it "returns false when taking own piece vertically" do
        board.setSquare("d1", Rook.new(:black))              
        board.setSquare("d8", Rook.new(:black))
        m1 = Move.new(board, board.getPieceAt("d1"), "d8", "d1")
        m2 = Move.new(board, board.getPieceAt("d8"), "d1", "d8")
                                                             
        expect(rules.isValidRookMove?(m1)).to eq false
        expect(rules.isValidRookMove?(m2)).to eq false
      end
    end
  end

  describe "#isValidKnightMove?" do
    it "returns true when moving in L" do
      board.setSquare("e4", Knight.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "c3","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "g3","e4")
      m3 = Move.new(board, board.getPieceAt("e4"), "d6","e4")
      m4 = Move.new(board, board.getPieceAt("e4"), "f6","e4")
      m5 = Move.new(board, board.getPieceAt("e4"), "g5","e4")
      m6 = Move.new(board, board.getPieceAt("e4"), "c5","e4")
      m7 = Move.new(board, board.getPieceAt("e4"), "d2","e4")
      m8 = Move.new(board, board.getPieceAt("e4"), "f2","e4")


      expect(rules.isValidKnightMove?(m1)).to eq true
      expect(rules.isValidKnightMove?(m2)).to eq true
      expect(rules.isValidKnightMove?(m3)).to eq true
      expect(rules.isValidKnightMove?(m4)).to eq true
      expect(rules.isValidKnightMove?(m5)).to eq true
      expect(rules.isValidKnightMove?(m6)).to eq true
      expect(rules.isValidKnightMove?(m7)).to eq true
      expect(rules.isValidKnightMove?(m8)).to eq true
    end

    it "returns false when moving in row" do
      board.setSquare("e4", Knight.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "e5","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "e3","e4")
      expect(rules.isValidKnightMove?(m1)).to eq false
      expect(rules.isValidKnightMove?(m2)).to eq false
    end
    
    it "returns false when moving in col" do
      board.setSquare("e4", Knight.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "a4","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "h4","e4")
      expect(rules.isValidKnightMove?(m1)).to eq false
      expect(rules.isValidKnightMove?(m2)).to eq false
    end

    it "returns false when moving in diagonal" do
      board.setSquare("e4", Knight.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "f3","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "d5","e4")
      expect(rules.isValidKnightMove?(m1)).to eq false
      expect(rules.isValidKnightMove?(m2)).to eq false
    end

    it "returns false when moving into its own piece" do
      board.setSquare("e4", Knight.new(:black))              
      board.setSquare("c3", Knight.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "c3","e4")
      expect(rules.isValidKnightMove?(m1)).to eq false
    end

    it "returns true when capturing"  do
      board.setSquare("e4", Knight.new(:black))              
      board.setSquare("c3", Knight.new(:white))              
      m1 = Move.new(board, board.getPieceAt("e4"), "c3","e4")
      expect(rules.isValidKnightMove?(m1)).to eq true
    end
  end

  describe "#isvalidBishopMove?" do
    it "returns false when moving in row" do                  
      board.setSquare("e4", Bishop.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "e5","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "e3","e4")
      expect(rules.isValidBishopMove?(m1)).to eq false
      expect(rules.isValidBishopMove?(m2)).to eq false
    end
    
    it "returns false when moving in col" do
      board.setSquare("e4", Bishop.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "a4","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "h4","e4")
      expect(rules.isValidBishopMove?(m1)).to eq false
      expect(rules.isValidBishopMove?(m2)).to eq false
    end

    it "returns true when moving in diagonal" do
      board.setSquare("e4", Bishop.new(:black))              
      m1 = Move.new(board, board.getPieceAt("e4"), "f3","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "d5","e4")
      expect(rules.isValidBishopMove?(m1)).to eq true
      expect(rules.isValidBishopMove?(m2)).to eq true
    end

    it "returns false when moving through a piece" do
      board.setSquare("e4", Bishop.new(:black))               
      board.setSquare("c6", Bishop.new(:black))               
      board.setSquare("f3", Bishop.new(:white))               
      m1 = Move.new(board, board.getPieceAt("e4"), "h1","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "a8","e4")
      expect(rules.isValidBishopMove?(m1)).to eq false
      expect(rules.isValidBishopMove?(m2)).to eq false
    end

    it "returns false when moving into it's own piece" do
      board.setSquare("e4", Bishop.new(:black))               
      board.setSquare("c6", Bishop.new(:black))               
      board.setSquare("f3", Bishop.new(:black))               
      m1 = Move.new(board, board.getPieceAt("e4"), "c6","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "f3","e4")
      expect(rules.isValidBishopMove?(m1)).to eq false
      expect(rules.isValidBishopMove?(m2)).to eq false
    end

    it "returns true when capturing an enemy piece" do
      board.setSquare("e4", Bishop.new(:black))               
      board.setSquare("c6", Bishop.new(:white))               
      board.setSquare("f3", Bishop.new(:white))               
      m1 = Move.new(board, board.getPieceAt("e4"), "c6","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "f3","e4")
      expect(rules.isValidBishopMove?(m1)).to eq true
      expect(rules.isValidBishopMove?(m2)).to eq true
    end
  end


  describe "#isValidKingMove?" do
    it "can move in one space in any direction" do
      board.setSquare("e4", King.new(:white))
      m1 = Move.new(board, board.getPieceAt("e4"), "e5","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "f5","e4")
      m3 = Move.new(board, board.getPieceAt("e4"), "d5","e4")
      m4 = Move.new(board, board.getPieceAt("e4"), "e3","e4")
      m5 = Move.new(board, board.getPieceAt("e4"), "f3","e4")
      m6 = Move.new(board, board.getPieceAt("e4"), "d3","e4")
      m7 = Move.new(board, board.getPieceAt("e4"), "d4","e4")
      m8 = Move.new(board, board.getPieceAt("e4"), "f4","e4")
      
      expect(rules.isValidKingMove?(m1)).to eq true
      expect(rules.isValidKingMove?(m2)).to eq true
      expect(rules.isValidKingMove?(m3)).to eq true
      expect(rules.isValidKingMove?(m4)).to eq true
      expect(rules.isValidKingMove?(m5)).to eq true
      expect(rules.isValidKingMove?(m6)).to eq true
      expect(rules.isValidKingMove?(m7)).to eq true
      expect(rules.isValidKingMove?(m8)).to eq true
    end

    it "can't move more than one in any direction"  do
      board.setSquare("e4", King.new(:white))
      m1 = Move.new(board, board.getPieceAt("e4"), "e6","e4")
      m2 = Move.new(board, board.getPieceAt("e4"), "g6","e4")
      m3 = Move.new(board, board.getPieceAt("e4"), "c6","e4")
      m4 = Move.new(board, board.getPieceAt("e4"), "e2","e4")
      m5 = Move.new(board, board.getPieceAt("e4"), "g2","e4")
      m6 = Move.new(board, board.getPieceAt("e4"), "c2","e4")
      m7 = Move.new(board, board.getPieceAt("e4"), "c4","e4")
      m8 = Move.new(board, board.getPieceAt("e4"), "g4","e4")
      
      expect(rules.isValidKingMove?(m1)).to eq false
      expect(rules.isValidKingMove?(m2)).to eq false
      expect(rules.isValidKingMove?(m3)).to eq false
      expect(rules.isValidKingMove?(m4)).to eq false
      expect(rules.isValidKingMove?(m5)).to eq false
      expect(rules.isValidKingMove?(m6)).to eq false
      expect(rules.isValidKingMove?(m7)).to eq false
      expect(rules.isValidKingMove?(m8)).to eq false
    end

    it "can capture enemy pieces" do
      board.setSquare("e4", King.new(:white))
      board.setSquare("e5", Pawn.new(:black))
      m1 = Move.new(board, board.getPieceAt("e4"), "e5","e4")
      expect(rules.isValidKingMove?(m1)).to eq true
    end

    it "cannot capture its own pieces" do
      board.setSquare("e4", King.new(:white))
      board.setSquare("e5", Pawn.new(:white))
      m1 = Move.new(board, board.getPieceAt("e4"), "e5","e4")
      expect(rules.isValidKingMove?(m1)).to eq false
    end
  end

  context  "returns array of moves with the .from attribute 
                         of move inferred from pieces on the board" do
    it " returns 2 knight moves " do
      expectedFroms = [ "b1", "g1"]
      board.setStartingPosition
      possibleFroms = []
      rules.getPossibleMoves(Move.new(board, Knight.new(:white),"c3")
                             ).each do |x|
        possibleFroms << x.from
      end
      expect(possibleFroms).to eq expectedFroms 
    end
  end

  describe "#isInCheck?" do
    context "given a colour" do
      it "returns true if that colours king is attacked" do
        board.setSquare("e8",King.new(:black))
        board.setSquare("e1",Queen.new(:white))
        expect(rules.isInCheck?(:black, board)).to eq true
      end
      it "returns false if that colours king is not attacked" do  
        board.setSquare("e8",King.new(:black))
        board.setSquare("d1",Queen.new(:white))
        expect(rules.isInCheck?(:black, board)).to eq false
      end
    end
  end
end

describe Move do
  let(:board){ Board.new }
  let(:move) { Move.new(board, :Knight, "e4", "c3") }

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
  let (:board ) { Board.new}

  describe "#parseMove" do                                              
    context "when given a valid move" do
      it "returns true on a normal move" do
        m = Move.new(board, Knight.new(:white), "e3")
        expect(parser.parseMove(board, "Ne3")).to eq m
      end
                                                                         
      it "returns true on a pawn move" do
        m1 = Move.new(board, Pawn.new(:white), "e4")
        m2 = Move.new(board, Pawn.new(:white), "e3")
        expect(parser.parseMove(board, "e4")).to eq m1
        expect(parser.parseMove(board, "Pe3")).to eq m2
      end
                                                                         
      it "return true on a check" do

        m1 = Move.new(board, Pawn.new(:white), "e4")
        m2 = Move.new(board, Bishop.new(:white), "b4")
        expect(parser.parseMove(board, "e4+")).to eq m1
        expect(parser.parseMove(board, "Bb4+")).to eq m2
      end
                                                                         
      it "returns ture on castling" do
        m1 = Move.new(board, King.new(:white), "g1")
        m2 = Move.new(board, King.new(:white), "c1")
        expect(parser.parseMove(board, "o-o")).to eq m1
        expect(parser.parseMove(board, "o-o-o")).to eq m2
      end
                                                                         
      it "returns true on pawn captures" do
        m1 = Move.new(board, Pawn.new(:white), "d4")
        expect(parser.parseMove(board, "exd4")).to eq m1
      end
                                                                         
      it "returns true on promotions" do
        m1 = Move.new(board, Pawn.new(:white), "a8")
        m2 = Move.new(board, Pawn.new(:white), "h1")
        expect(parser.parseMove(board, "a8=Q")).to eq m1
        expect(parser.parseMove(board, "Ph1=N")).to eq m2
      end
                                                                         
      it "returns true when two of the same piece can go to a square" do
        m1 = Move.new(board, Knight.new(:white), "e3", "d5")
        expect(parser.parseMove(board, "Nd5-e3")).to eq m1
      end
    end
                                                                         
    context "when given an invalid move" do
      it " returns on first invalid first character" do
        expect(parser.parseMove(board, "Zd4-e3")).to eq false
      end
                                                                         
      it " return false on move too far right" do
        expect(parser.parseMove(board, "Ni5")).to eq false
      end
                                                                         
      it " returns false on a move too far up" do
        expect(parser.parseMove(board, "Na9")).to eq false
      end
                                                                         
      it " returns false on gibberish" do
        expect(parser.parseMove(board, "iakjdlsfl;k")).to eq false
      end
                                                                         
      it " returns false on empty input" do
        expect(parser.parseMove(board, "")).to eq false
      end
                                                                         
      it " returns false with two pawn moves entered" do
        expect(parser.parseMove(board, "e4e4")).to eq false
                                                                         
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


