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
        guess == word
    end

    def display_board(guesses, guess, word)
        puts "Guesses: #{guesses.join(" ")}"
        puts "The word: #{word}"
    end
end


class Game
    include Player
    include Computer
    include Board
    attr_accessor :word, :guesses, :this_guess, :turn, :winner
    def initialize
        @word = word
        @this_guess = ""
        @guesses = []
        @turn = 1
        @winner = false
    end
    def intro
        puts "Welcome to HangMan!"
        puts "Try to guess the randomly selected word within 12 tries."
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
        until @turn == 13
            if win?(this_guess.downcase, word) == false
                puts ""
                puts "Turn #{turn}:"
                this_guess = make_guess(guesses)
                guesses.push(this_guess.downcase)
                display_board(guesses, this_guess.downcase, word)
                puts win?(this_guess.downcase, word)
                @turn += 1
                if win?(this_guess.downcase, word) == true
                    puts "You win!"
                    @turn = 13
                end
            end
        end
    end
end

start = Game.new
start.intro
