require 'pry'
require "yaml"

module Player
    def make_guess(guesses)
        puts ""
        puts "Enter a letter or full word to guess:"
        player_guess = gets.chomp.to_s
        check_guess = player_guess
        until check_guess = valid?(guesses, check_guess)
            puts "Invalid (already entered the word or letter, or includes a number) try again:"
            check_guess = gets.chomp.to_s
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
    def win?(guess, word, clue)
        guess == word || clue == word
    end

    def display_board(guesses, word, clue, turn)
        puts "\nTurn #{turn}:\n"
        print "#{clue.join(' ')} \n"
        puts "\nGuesses: #{guesses.join(" ")}"
    end
end


class Game
    include Player
    include Computer
    include Board
    attr_accessor :word, :guesses, :this_guess, :turn, :clue
    def initialize
        @word = word
        @this_guess = ""
        @guesses = guesses
        @turn = turn
        @clue = clue
    end
    def intro
        @clue = []
        @turn = 1
        @guesses = []
        puts "Welcome to HangMan!"
        puts "Try to guess the randomly selected word within 12 tries."
        puts ""
        puts "Commands:"
        puts ":s - save game"
        puts ":l - load game"
        puts ""
        words = find_word
        word = words.sample
        word.length.times do |e|
            clue.push('_')
        end
        play_game(word)
    end

    def check_clue(guess, word)
        check_word = word.split("")
        if guess.length == 1
            check_word.each_with_index do |e, idx|
                if e == guess
                    clue[idx] = e
                end
            end
        end
    end

    def play_game(word)
        puts "\nTurn #{turn}:\n"
        print "#{clue.join(' ')} \n"
        until @turn == 13
            this_guess = make_guess(guesses)

            if this_guess == ":s"
                puts "Saved!"
                saves = ["#{word}", "#{@guesses}", "#{@turn}", "#{@clue}"]
                save_file(saves)
            elsif this_guess == ":l"
                load_file
            else
                @turn += 1
                guesses.push(this_guess.downcase)
                check_clue(this_guess, word)
                display_board(guesses, word, @clue, @turn)
                if win?(this_guess.downcase, word, clue.join(""))
                    @turn = 14
                end
            end

            if @turn == 13
                puts "The word was: #{word}!"
                puts "You lose! Try again? (y/n)"
                try_again = gets.chomp.downcase
                if try_again == "y"
                    intro
                end
            end
            
            if @turn == 14
                puts "The word was: #{word}!"
                puts "You Win! Play again? (y/n)"
                try_again = gets.chomp.downcase
                if try_again == "y"
                    intro
                end
            end

        end
    end

    def save_file(save_data)
        save_file = File.open("saved.yaml", 'w') do |save_file|
            save_file.write YAML::dump(save_data)
        end
    end
    
    def load_file
        loaded = YAML.load(File.read("saved.yaml"))
        loaded_arr = []
        loaded.each do |element|
            loaded_arr.push(element)
        end
        @word = loaded_arr[0].tr(" ,'\"[]", "")
        @guesses = loaded_arr[1].tr(" ,'\"[]", "").split("")
        @turn = loaded_arr[2]
        @clue = loaded_arr[3].tr(" ,'\"[]", "").split("")
        display_board(guesses, word, @clue, @turn)
        this_guess = make_guess(guesses)
        play_game(@word)

    end

end

start = Game.new
start.intro

