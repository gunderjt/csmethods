#Jeffrey Gunderson

# Part1: Hello World
class HelloWorldClass
    def initialize(name)
       @name = name.capitalize
    end
    def sayHi
        puts "Hello #{@name}!"
    end
end

def palindrome?(string)

  string = string.gsub(/[^a-zA-Z]/, '')
  string = string.downcase
  if (string === string.reverse)
    return true
  else
    return false
  end
end

def count_words(string)

  string = string.gsub(/[^a-zA-Z ]/, '')
  string = string.downcase
  words = string.split
  hashWord = Hash.new
  words.each {|word|
    if(hashWord.has_key?(word))
      hashWord[word] = hashWord[word] + 1
    else
      hashWord[word] = 1
    end
  }
  puts hashWord.inspect
end

class WrongNumberOfPlayersError <  StandardError ; end
class NoSuchStrategyError <  StandardError ; end

def validStrategy?(strategy)
  strategy = strategy.downcase
  valid = ["r", "p", "s"]
  if(valid.include?(strategy))
    return true
  else
    return false
  end
end

def secondPlayerWin?(firstPlayer, secondPlayer)
  firstPlayer = firstPlayer.downcase
  secondPlayer = secondPlayer.downcase
  if(firstPlayer == "r" && secondPlayer == "p")
    return true
  elsif (firstPlayer == "p" && secondPlayer == "s")
    return true
  elsif (firstPlayer == "s" && secondPlayer == "r")
    return true
  else
    return false
  end
end

def rps_game_winner(game)
  raise WrongNumberOfPlayersError unless game.length == 2
  raise NoSuchStrategyError unless validStrategy?(game[0][1]) && validStrategy?(game[1][1])
  if(secondPlayerWin?(game[0][1], game[1][1]))
    return game[1]
  else
    return game[0]
  end
end




def rps_tournament_winner(bracket)
  if (bracket[0][0].is_a?(String))
    return rps_game_winner(bracket)
  end
  newBracket = Array.new
  newBracket << rps_tournament_winner(bracket[0])
  newBracket << rps_tournament_winner(bracket[1])
  return rps_game_winner(newBracket)
end

def combine_anagrams(words)
  inOrder = words.group_by { |word|
    word.downcase.chars.sort
  }
  inOrder.values
end

words = ['cars', 'for', 'potatoes', 'racs', 'four', 'scar', 'creams', 'scream']

print (combine_anagrams(words))

bracket = [
           [
            [["Armando", "P"], ["Dave", "S"]],
            [["Richard", "R"], ["Michael", "S"]],
           ],
           [
            [["Allen", "S"], ["Omer", "P"]],
            [["David E.", "R"], ["Richard X.", "P"]]
           ]
          ]

#puts rps_tournament_winner(bracket)


#puts rps_game_winner([ ["Armando", "S"], ["Dave", "R"] ])

#count_words("A man, a plan, a canal -- Panama")
#count_words("doo bee doo bee doo")


#hello = HelloWorldClass.new("jeffrey gunderson")
#hello.sayHi

#palindrome?("A man, a plan, a canal -- Panama")
#palindrome?("Madam, I'm Adam!")
#palindrome?("Abracadabra")
