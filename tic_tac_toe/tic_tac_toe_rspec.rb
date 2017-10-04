
require "./lib/tic_tac_toe.rb"

describe "a game of tic tac toe" do

  describe "creating the board" do
    context "creating a 3x3 board" do
      it "creates the board with no errors " do
        expect{TicTacToeBoard.new 3}.to_not raise_error
      end

      it "raises an error on a board size of 1" do
        expect{TicTacToeBoard.new 1}.to raise_error(ArgumentError)
      end

      it "raises an error on a board size of 0" do
        expect{TicTacToeBoard.new 0}.to raise_error(ArgumentError)
      end

      it "raises an error on a board size of < 0" do
        expect{TicTacToeBoard.new -3}.to raise_error(ArgumentError)
      end
    end
  end


  describe "win conditions" do
    subject(:test_board) { TicTacToeBoard.new 3 }
    
    context "X player gets a row" do
      let(:test_row_win){
       test_board.squares[0] = XSquare.new 0 
       test_board.squares[1] = XSquare.new 1
       test_board.squares[2] = XSquare.new 2
      }

      context "last move was at start of row" do
        it "ends the game" do
          test_row_win
          expect(test_board.checkLastMoveForWin(0)).to eq(true)
        end
      end
      context "last move was in middle of row" do
        it "ends the game" do
          test_row_win
          expect(test_board.checkLastMoveForWin(1)).to eq(true)
        end
      end
      context "last move was at end of row" do
        it "ends the game" do
          test_row_win
          expect(test_board.checkLastMoveForWin(2)).to eq(true)
        end
      end
    end

    context "player gets a col" do
      let(:test_col_win){
        test_board.squares[0] = XSquare.new 0
        test_board.squares[3] = XSquare.new 3
        test_board.squares[6] = XSquare.new 6
      }

      context "last move was at start of col" do
        it "ends the game" do
          test_col_win
          expect(test_board.checkLastMoveForWin(0)).to eq(true)
        end
      end
      context "last move was in middle of col" do
        it "ends the game" do
          test_col_win
          expect(test_board.checkLastMoveForWin(3)).to eq(true)
        end
      end
      context "last move was at end of col" do
        it "ends the game" do
          test_col_win
          expect(test_board.checkLastMoveForWin(6)).to eq(true)
        end
      end
    end

    context "player gets a positive diagonal" do
      let(:test_pos_diag_win){
        test_board.squares[0] = XSquare.new 0
        test_board.squares[4] = XSquare.new 4
        test_board.squares[8] = XSquare.new 8
      }
                                                                
      context "last move was at start of diagonal" do
        it "ends the game" do
          test_pos_diag_win
          expect(test_board.checkLastMoveForWin(0)).to eq(true)
        end
      end
      context "last move was in middle of diagonal" do
        it "ends the game" do
          test_pos_diag_win
          expect(test_board.checkLastMoveForWin(4)).to eq(true)
        end
      end
      context "last move was at end of diagonal" do
        it "ends the game" do
          test_pos_diag_win
          expect(test_board.checkLastMoveForWin(8)).to eq(true)
        end
      end
    end

    context "player gets a negative diagonal" do
      let(:test_neg_diag_win){
        test_board.squares[2] = XSquare.new 2
        test_board.squares[4] = XSquare.new 4
        test_board.squares[6] = XSquare.new 6
      }
                                                                
      context "last move was at start of diagonal" do
        it "ends the game" do
          test_neg_diag_win
          expect(test_board.checkLastMoveForWin(4)).to eq(true)
        end
      end
      context "last move was in middle of diagonal" do
        it "ends the game" do
          test_neg_diag_win
          expect(test_board.checkLastMoveForWin(4)).to eq(true)
        end
      end
      context "last move was at end of diagonal" do
        it "ends the game" do
          test_neg_diag_win
          expect(test_board.checkLastMoveForWin(6)).to eq(true)
        end
      end
    end

    context "0 player gets a row" do
      let(:test_O_row_win){
       test_board.squares[0] = OSquare.new 0
       test_board.squares[1] = OSquare.new 1 
       test_board.squares[2] = OSquare.new 2
      }
                                                                
      context "last move was at start of row" do
        it "ends the game" do
          test_O_row_win
          expect(test_board.checkLastMoveForWin(0)).to eq(true)
        end
      end
      context "last move was in middle of row" do
        it "ends the game" do
          test_O_row_win
          expect(test_board.checkLastMoveForWin(1)).to eq(true)
        end
      end
      context "last move was at end of row" do
        it "ends the game" do
          test_O_row_win
          expect(test_board.checkLastMoveForWin(2)).to eq(true)
        end
      end
    end

    context "full board with no winner"    
      let(:test_draw){
       test_board.squares[0] = OSquare.new 0
       test_board.squares[1] = XSquare.new 1
       test_board.squares[2] = OSquare.new 2 
       
       test_board.squares[3] = OSquare.new 3 
       test_board.squares[4] = XSquare.new 4 
       test_board.squares[5] = OSquare.new 5 

       test_board.squares[6] = XSquare.new 6 
       test_board.squares[7] = OSquare.new 7  
       test_board.squares[8] = XSquare.new 8 
      }

      it "should find no winners for any last move" do
        for i in 0..8 do
          test_draw
          expect(test_board.checkLastMoveForWin(i)).to eq false
        end
      end
    end

  describe "validate user input" do 
    subject(:game) { game =  TicTacToeGame.new 3}

    context "given invalid input" do
      it "returns empty string if not a number" do
        expect(game.validateInput("not number","Player X")).to eq ""
      end
      it "returns empty string if number is out of range" do
        expect(game.validateInput("100","Player X")).to eq ""
      end
      it "returns empty string if square is taken" do
        game.squares[0] = XSquare.new 0
        expect(game.validateInput("0","Player X")).to eq ""
      end
    end

    context "given valid input" do
      it "returns the input back" do
        game
        expect(game.validateInput("4","Player X")).to eq "4"
      end
    end
  end
end
