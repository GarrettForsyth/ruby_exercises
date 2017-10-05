class Connect4 

  attr_accessor :player1, :player2, :board, :turn_count, :game_over, :last_move

  def initialize()
    @player1 = Player.new "X"
    @player2 = Player.new "O"
    @board   = Connect4Board.new
    @turn_count = 0
    @last_move = {col: -1, row: -1}
    @game_over = false
  end

  def startGame
    turnPhase
  end

  # For some reason ruby wrapped the hash in an array when
  # only using attr_accessor :last_move
  def last_move
    @last_move
  end

  def turnPhase

    while not @game_over do
      @board.drawBoard
      users_move = promptUser
      updateBoard users_move
      @game_over = gameOver?
      @turn_count += 1
    end
    puts "Thanks for playing!"

  end

  def updateBoard users_move
    marker = getPlayerTurn
    row = @board.columns[users_move.to_i].addMarker marker
    @last_move = {col: users_move.to_i, row: row}
  end

  def promptUser
    print "#{getPlayerTurn}'s turn. Enter a column #: "
    response = gets
    return response if validResponse? response
    
    return if response.nil? # TODO this link is only included for testing
    puts "Response must be a in the range [0,6]."
    promptUser
  end

  # Note, regex would have be be changed manually here
  # if the NUMBER_OF_COLUMNS were to change
  def validResponse? response
    return false unless /^[0-7]$/ =~ response.to_s 
    return false if @board.isColFull? response.to_i
    true
  end

  def getPlayerTurn
    if @turn_count % 2 == 0 then marker = "X"
    else marker = "O" end                        
  end

  def gameOver?
    if @turn_count == 42
      puts "Game Over. It's a tie!"
      return true
    end
    return true if checkForColWin
    return true if checkForRowWin
    return true if checkForNegDiagWin
    return true if checkForPosDiagWin
    false
  end

  def checkForColWin
    return false if @last_move[:row] < 3
    row = @last_move[:row] - 1
    for i in (row).downto(row-2) do
      return false unless @board.columns[@last_move[:col]].slots[i].content == getPlayerTurn
    end
    true
  end

  def checkForRowWin
    c = @last_move[:col]
    r = @last_move[:row]
    count = 1 + countToLeft(c-1,r) + countToRight(c+1,r)
    return false unless count  >= 4 
    true
  end

  def countToRight c,r 
    return 0 if c == 7 
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToRight(c+1,r)
  end

  def countToLeft c,r 
    return 0 if c == -1 
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToRight(c-1,r)
  end

  def checkForPosDiagWin
    c = @last_move[:col]
    r = @last_move[:row]                                 
    count = 1 + countToDownAndLeft(c-1,r-1) + countToUpAndRight(c+1,r+1)
    return false unless count  >= 4 
    true
  end

  def countToUpAndRight c,r
    return 0 if c == 7 ||  r == 6
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToUpAndLeft(c+1,r+1)
  end

  def countToDownAndLeft c,r
    return 0 if c == -1 ||  r == -1
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToDownAndLeft(c-1,r-1)
  end

  def checkForNegDiagWin
    c = @last_move[:col]
    r = @last_move[:row]                                 
    count = 1 + countToUpAndLeft(c-1,r+1) + countToDownAndRight(c+1,r-1)
    return false unless count  >= 4 
    true
  end

  def countToUpAndLeft c,r
    return 0 if c == -1 ||  r == 6                                
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToUpAndLeft(c-1,r+1)
  end

  def countToDownAndRight c,r
    return 0 if c == 7 ||  r == -1                                
    return 0 if @board.columns[c].slots[r].content!=getPlayerTurn 
    return 1 + countToDownAndRight(c+1,r-1)
  end

end

class Player

  attr_accessor :marker

  def initialize(marker_symobl)
    @marker = marker_symobl
  end

end

class Connect4Board

  attr_accessor :columns
  NUMBER_OF_COLUMNS = 7
  NUMBER_OF_SLOTS   = 6

  def initialize
    @columns = []
    NUMBER_OF_COLUMNS.times { @columns << Connect4Column.new }
  end

  def isColFull? col_num
    return @columns[col_num].isFull?
  end

  def drawBoard
    for i in (NUMBER_OF_SLOTS-1).downto(0) do
      drawBar 4*NUMBER_OF_COLUMNS
      drawRow i 
    end
    drawLabels
  end

  def drawBar num
    num.times  {print"-" }
    puts "-"
  end

  def drawRow row_num
    for i in 0...NUMBER_OF_COLUMNS do
      print "| "
      print "#{@columns[i].slots[row_num].draw}"
      print " "
    end
    puts "|"
  end

  def drawLabels
    2.times {drawBar 4*NUMBER_OF_COLUMNS}
    for i in 0...NUMBER_OF_COLUMNS do
      print "| #{i} "
    end
    puts "|"
    drawBar 4*NUMBER_OF_COLUMNS
 end

end

class Connect4Column

  attr_accessor :slots
  NUMBER_OF_SLOTS = 6

  def initialize
    @slots = []
    NUMBER_OF_SLOTS.times { @slots << Connect4Slot.new }
  end

  # A column is full if its top slot is not blank
  def isFull? 
   return @slots[NUMBER_OF_SLOTS-1].content != " " 
  end

  # Changes the content of the top Slot to marker,
  # and then sinks until there are empty slots underneath
  # Returns the row the marker settled in
  def addMarker marker
    @slots[NUMBER_OF_SLOTS-1].content = marker
    i = (NUMBER_OF_SLOTS) -1
    while i != 0 && @slots[i-1].content == " " do
      sink i 
      i -= 1
    end
    i
  end

  # Swap slot's content if space underneath is blank
  def sink i
    @slots[i-1].content = @slots[i].content 
    @slots[i].content = " "
  end

end

class Connect4Slot

  attr_accessor :content
  DEFAULT_CONTENT = " "

  def initialize content=DEFAULT_CONTENT
    @content = content
  end

  def draw
    print @content
  end
end
