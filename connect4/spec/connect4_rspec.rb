require "../lib/connect4.rb"

describe Connect4 do

   let(:game){Connect4.new}

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

  describe "creating a new game" do
    describe "#new" do
      it "creates a new game instance" do
        expect(game).to be_an_instance_of(Connect4)
      end

      it "creates 2 players" do
        expect(game.player1).to be_an_instance_of Player
        expect(game.player2).to be_an_instance_of Player
      end

      it "creates a game board" do
        expect(game.board).to be_an_instance_of Connect4Board
      end

      it "sets turn_count to 0" do
        expect(game.turn_count).to eq 0
      end
    end
  end

  describe "#startGame" do
    it "begins the turn phase" do
      expect(game).to receive(:turnPhase)
      game.startGame
    end
  end

  describe "#turnPhase" do
    it "prompts the user for a move" do
      expect(game).to receive(:promptUser)
      game.startGame
    end

    it "adds the users move to the board" do
      expect(game).to receive(:updateBoard)
      game.turnPhase
    end

    it "increments the turn count" do
      expect{game.turnPhase}.to change{game.turn_count}.from(0).to(1)
    end

    it "checks if the game is over" do
      expect(game).to receive(:gameOver?)
      game.turnPhase
    end
  end

  describe "#promptUser" do
    it "prompts the user to give a col #" do
      prompt = "X's turn. Enter a column #: "
      allow(game).to receive(:gets) { "5" }
      expect{ game.promptUser }.to output(prompt).to_stdout
    end 

    it "gets the users response" do
      expect(game).to receive(:gets)
      game.promptUser
    end

    it "validates the users response" do
      expect(game).to receive(:validResponse?)
      game.promptUser
    end

    it "will reprompt on bad input until good input" do
      allow(game).to receive(:gets) do
        @counter ||= 0
        response = if @counter < 3
                     "BAD INPUT"
                   else
                     "5" # Good input
                   end
        @counter +=1
        response
      end

      expectedOutput = "X's turn. Enter a column #: Response must be a in the range [0,6].\n"*3 + "X's turn. Enter a column #: "

      expect{ game.promptUser }.to output(expectedOutput).to_stdout
    end
  end

  describe "#updateBoard" do                                      
    context "a user makes a valid move" do
      it "updates the board with the move" do        
        game.updateBoard 0
        expect(game.board.columns[0].slots[0].content).to eq "X"
      end
    end
  end

  describe "#getPlayerTurn" do
    context "even turn count" do
      it "returns 'X' for X' player's turn" do
        game.turn_count = 0
        expect(game.getPlayerTurn).to eq "X"
      end
    end
    context "even turn odd" do
      it "returns 'O' for O' player's turn" do
        game.turn_count = 1
        expect(game.getPlayerTurn).to eq "O"
      end
    end
  end

  describe "#validResponse?" do
    context "given a valid response" do
      it "returns true" do
        expect(game.validResponse?("0")).to eq true
      end
    end

    context "given an invalid response" do
      context "a response that's not length 1" do
        it "returns false" do
          expect(game.validResponse?("AA")).to eq false
        end
      end
      context "given a numbers out of range" do
        it "returns false" do
          expect(game.validResponse?("-1")).to eq false
        end
        it "returns false" do
          expect(game.validResponse?("10")).to eq false
        end
      end
      context "given a row that's already full" do
        it "returns false" do
          6.times { game.board.columns[0].addMarker "X" }
          expect(game.validResponse?("0")).to eq false
        end
      end
    end
  end

  describe "#gameOver?" do
    context "a game ending condition has not been reached." do
      it "returns false" do
        expect(game.gameOver?).to eq false
      end
    end

    context "a game ending condition has been reached" do
      context "the maximum amount of moves has been made" do
        it "returns true" do
          MAXIMUM_NUMBER_OF_MOVES = 7*6
          game.turn_count = MAXIMUM_NUMBER_OF_MOVES 
          expect(game.gameOver?).to eq true
        end
      end
      context "a user has 4 markers in a column" do
        it "returns true" do
          4.times {game.updateBoard "0"}
          expect(game.gameOver?).to eq true
        end
      end
      context "a user has 4 markers in a row" do
        it "returns true" do
          game.updateBoard "0"
          game.updateBoard "1"
          game.updateBoard "2"
          game.updateBoard "3"
          expect(game.gameOver?).to eq true
        end
      end
      context "a user has 4 markers on the +ve diagonal" do
        it "returns true" do
          for i in 1..3 do
            for j in i..3 do
              game.updateBoard j
            end
          end
          game.turn_count += 1
          for i in 0..3 do
            game.updateBoard i
          end
          expect(game.gameOver?).to eq true
        end
      end
      context "a user has 4 markers on the -ve diagonal" do
        it "returns true" do
          for i in 0..2 do
            for j in i.downto(0) do
              game.updateBoard j
            end
          end
          game.turn_count += 1
          for i in 0..3 do
            game.updateBoard i
          end
          expect(game.gameOver?).to eq true
        end
      end
    end
  end

  describe "#checkForColWin" do
    context "last move did not create 4 markers in a col" do
      it "returns false" do
        game.last_move = {col: 0, row: 0}
        expect(game.checkForColWin).to eq false
      end
    end
    context "last move created 4 markers in a col" do
      it "returns true" do
        4.times {game.updateBoard "0"}
        expect(game.checkForColWin).to eq true
      end
    end
  end

  describe "#checkForRowWin" do
    context "last move did not create 4 markers in a row" do
      it "returns false" do
        game.last_move = {col: 0, row: 0}
        expect(game.checkForColWin).to eq false
      end
    end
    context "last move created 4 markers in a row" do
      it "returns true" do
        game.updateBoard "0"
        game.updateBoard "1"
        game.updateBoard "2"
        game.updateBoard "3"
        expect(game.checkForRowWin).to eq true
      end
    end
  end

  describe "#checkForPosDiagWin" do
    context "last move did not create 4 markers in a +ve diagonal" do
      it "returns false" do
        game.last_move = {col: 0, row: 0}
        expect(game.checkForPosDiagWin).to eq false
      end
    end
    context "last move created 4 markers in a +ve diag" do
      it "returns true" do
        for i in 1..3 do
          for j in i..3 do
            game.updateBoard j
          end
        end
        game.turn_count += 1
        for i in 0..3 do
          game.updateBoard i
        end
        expect(game.checkForPosDiagWin).to eq true
      end
    end
  end

  describe "#checkForNegDiagWin" do                                   
    context "last move did not create 4 markers in a -ve diagonal" do
      it "returns false" do
        game.last_move = {col: 0, row: 0}
        expect(game.checkForNegDiagWin).to eq false
      end
    end
    context "last move created 4 markers in a -ve diag" do
      it "returns true" do
        for i in 0..2 do
          for j in i.downto(0) do
            game.updateBoard j
          end
        end
        game.turn_count += 1
        for i in 0..3 do
          game.updateBoard i
        end
        expect(game.checkForNegDiagWin).to eq true
      end
    end
  end


  describe "#getLastMove" do
    context "multiple moves made in same column" do
      it "updates to 0,0 on first token" do
        game.updateBoard 0
        expect(game.last_move).to eq({col: 0,row: 0})
      end
      it "updates to 0,1 on the second token" do
        2.times {game.updateBoard 0} 
        expect(game.last_move).to eq({col: 0, row: 1})
      end
     end
    context "multiple moves made in same row" do
      it "updates to 1,0 on the second token" do
        game.updateBoard 0
        game.updateBoard 1
        expect(game.last_move).to eq({col: 1, row: 0})
      end
    end
  end

  describe "a connect4 player" do
    let(:player){Player.new "X"}

    it "has a unique marker symbol represent squares on the board" do
      expect(player.marker).to be_an_instance_of String
    end

  end

  describe "a connect4 board" do
    let(:board){Connect4Board.new}

    it "contains 7 coloumns" do
      expect(board.columns.length).to eq 7
    end

    describe "#drawBoard" do
      it "draws its columns" do
        
      end
    end

  end

  describe "a connect4 column" do
    let(:col){Connect4Column.new}

    it "contains 6 slots" do
      expect(col.slots.length).to eql 6 
    end
  end

  describe "a connect4 slot" do
    let(:slot){Connect4Slot.new}

    it "draws its contents to the board" do
      expect{ slot.draw }.to output(slot.content).to_stdout
    end
  end

end

