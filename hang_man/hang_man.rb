require "json" 
class Hangman

  def initialize(platform="",word="", guessedLetters=[], correctLetters=[], wrongGuessCount=0, gameover=false)
    @platform = platform
    @word = word
    @correctLetters = correctLetters
    @guessedLetters = guessedLetters
    @wrongGuessCount = wrongGuessCount
    @gameover = gameover
  end
  

  def newGame
    @platform = %{ 
    ______  
    ||   |   
    ||         
    ||        
    ||         
    ||      
    ||||||||}

    pickWord
    @correctLetters = Array.new(@word.length-2, "_")
    @guessedLetters = Array.new
    @wrongGuessCount = 0
    @gameover = false
    drawPlatform 
    play
    
  end

  def play
    while @gameover == false
      puts ""
      promptUser
      puts ""
    end
  end

  def pickWord
    @word = ""
    dictionary = File.open("hangman_words.txt").read
    randLineNum = rand(getLineCount dictionary)
    dictionary.each_line.with_index do |line, index|
      if index === randLineNum
        @word= line.downcase
        return
      end
    end
  end

  def getLineCount file
    count = 0
    file.each_line {|line| count+=1}
    count
  end

  def promptUser
    validGuess = false

    while validGuess == false
      puts @correctLetters.join" "
      puts "Guessed letters #{@guessedLetters.join" "}" if !@guessedLetters.empty?
      print "Guess a letter:"

      guess = gets.chomp!
      if guess === "save" 
        saveGame
      end
      validGuess = validateGuess guess.downcase
    end
    processGuess guess
  end

  def saveGame
    filename = ""
    while filename == "" 
      print "Saving Game. Enter filename:"
      filename = gets.chomp!
      File.write(filename + ".json", self.to_json)
    end
  end

  def validateGuess guess
    puts "guess is #{guess}"
    validGuess = false
    if guess.length != 1
      puts "Guess only ONE letter at a time!"
      return false
    elsif not guess =~ /[a-z]/
      puts "Guess only LETTERS!"
      return false
    elsif @guessedLetters.include? guess
      puts "You've already guess that letter!"
      return false
    else 
      return true

    end
  end 
  def processGuess guess
    @guessedLetters << guess 

    i = @word.index(guess)
    if i then correctGuess i, guess
    else incorrectGuess guess  end
  end
  
  def correctGuess i, guess 
     while i 
       @correctLetters[i] = guess
       i = @word.index(guess, i+1)
     end
     if !@correctLetters.include?"_" 
       puts "You've guessed all the letters! You win"
       @gameover = true
     end
  end

  def incorrectGuess guess
    puts "The word does not contain any #{guess}'s.'"
    @wrongGuessCount += 1
    case @wrongGuessCount
    when 1
      drawHead
    when 2
      drawBody
    when 3
      drawLeftArm
    when 4
      drawRightArm
    when 5
      drawLeftLeg
    else
      drawRightLeg
      puts "You've lost!"
      puts "The word was #{@word}"
      @gameover = true
    end
  end
  

  def drawPlatform
    puts @platform
    puts ""
  end

  def drawHead
    @platform[38..39] = "0"
    drawPlatform
  end

  def drawBody
    @platform[53..54] = "|"
    drawPlatform
  end

  def drawLeftArm
    @platform[52..52] = "~"
    drawPlatform
  end

  def drawRightArm 
    @platform[54..54] = "~"
    drawPlatform
  end

  def drawLeftLeg
    @platform[66..66]="/"
    drawPlatform
  end

  def drawRightLeg
    @platform[68..68] = "\\"
    drawPlatform
  end

  def to_json(*a)
    {
      "json_class" => self.class.name,
      "data"       => {"platform" => @platform,
                      "word" => @word,
                      "guessedLetters" => @guessedLetters,
                      "correctLetters" => @correctLetters,
                      "wrongGuessCount" => @wrongGuessCount,
                      "gameover" => @gameover}
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o["data"]["pltaform"],
        o["data"]["word"],
        o["data"]["guessedLetters"],
        o["data"]["correctLetters"],
        o["data"]["wrongGuessCount"],
        o["data"]["gameover"])
  end
    

end

def start
   ans = loadGame?
   if ans === "Y"
     getSavedFile 
   else
     game = Hangman.new
     game.newGame
   end
end

def loadGame?
  ans = ""
  filename = ""
  while ans === ""
    print "Load previous game?(Y/N)"
    ans = gets.chomp!
    if ans =~ /Y|N/
      return ans
    else
      puts "Invalid response."
      ans = ""
    end
  end
  ans
end
                                      
def getSavedFile
  filename = ""
  while filename === "" 
    print "Enter name of saved file:"
    filename = gets.chomp!
    if !File.exists? filename
      puts "This file does not exist"
      return else loadGame filename
    end
  end
  return filename
end
                                      
def loadGame filename
  json_string = File.read(filename)
  a = JSON.parse(json_string)
  game = Hangman.new(a["data"]["platform"],
                     a["data"]["word"],
                     a["data"]["guessedLetters"],
                     a["data"]["correctLetters"],
                     a["data"]["wrongGuessCount"],
                     a["data"]["gameover"])
  
  if game.instance_of? Hangman
    puts "Game is Hangman object"
  else 
    puts "Game is NOT Hangman object."
  end
  game.play
end


start
