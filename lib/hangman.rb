require 'pry'

module Player
    def make_guess(guesses)
        puts "Enter a letter or full word to guess:"
        player_guess = gets.chomp.to_s
        check_guess = player_guess
        until check_guess = valid?(guesses, check_guess)
            puts "Invalid (already entered the word or letter, or includes a number) try again:"
            player_guess = gets.chomp.to_s
        end 
        return player_guess
    end

    def valid?(guesses, player_guess)
        if guesses.include?(Integer) || guesses.include?(player_guess)
            false
        else
            true
        end
    end
end

module Computer
    def find_word
        words = []
        dictionary = File.open("5desk.txt", "r").readlines.each do |line|
            line = line.strip.downcase
            if line.length >= 5 && line.length <= 12
                words.push(line)
            end
        end
        words
    end
end


module Board
    def win?(guess, word)
        if guess.to_s == word.to_s
            return true
        else return false
        end
    end
end

class Game
include Player
include Computer
include Board
attr_accessor :word, :guesses, :this_guess
    def initialize
        @word = word
        @this_guess = ""
        @guesses = []
    end
    def intro
        puts "Welcome to HangMan!"
        puts "Try to guess the randomly selected word within 8 tries."
        puts ""
        puts "Commands:"
        puts ":s - save game"
        puts ":l - load game"
        puts ""
        play_game
    end

    def play_game
        words = find_word
        word = words.sample
        puts word
        until win?(@this_guess, @word) == true
            this_guess = make_guess(guesses)
            guesses.push(this_guess)
            puts "Guesses: #{guesses.join(" ")}"
        end
    end
end

start = Game.new
start.intro
