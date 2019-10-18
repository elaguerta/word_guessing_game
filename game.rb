require 'httparty'

class Game
    attr_reader :secret_word, :game_word

    # Initialize: pull the dictionary from the REACH API. Pick a secret word at random from the dictionary
    # if it has not already been passed as an argument. Pass in the players. 
    def initialize(player, passed_word = nil)
        url = "http://app.linkedin-reach.io/words"
        response = HTTParty.get(url)
        dictionary = response.parsed_response.split("\n")
        passed_word ||= dictionary.sample

        @secret_word = passed_word
        @game_word = '_ '* @secret_word.length
        @player = player 
    end

    # play_round: implements basic game logic. Get a guess from the player. 
    # If it's a correct guess, show the occurences of that letter in the secret word. Update
    # player's correct guesses list.
    # If it's not a correct guess, let the player know, update incorrect guess list.
    # Either way update the player on their incorrect guesses and guesses remaining. 
    def play_round
        puts @game_word + "\n\n"
        guess = @player.get_guess
        if correct_guess?(guess)
            @player.correct_guesses += [guess]
        else
            @player.guesses_remaining -= 1
            @player.incorrect_guesses += [guess]
        end
        puts "Incorrect guesses: #{@player.incorrect_guesses}"
        puts "Guesses remaining: #{@player.guesses_remaining}"
        puts "_____________________________________"
        puts "\n\n"
    end

    def correct_guess?(guess)
        if guess.length == 1
            if @secret_word.include?(guess)
                puts "That letter is in the secret word!"
                (0..@secret_word.length).each do |index|
                    if @secret_word[index] == guess
                        @game_word[index * 2] = guess
                    end
                end
            else
                puts "That letter is not in the secret word."
            end
        else
            if @secret_word == guess
                @game_word = @secret_word.split("").join(" ")
            else
                puts "That word is not the secret word."
            end       
        end
    end

    # game_over: check if the win/lose conditions are met
    def game_over?
        self.lost? || self.won?
    end

    def lost?
        if @player.guesses_remaining == 0
            puts "You lost. The secret word is: #{@secret_word}\n\n"
            return true
        end
    end

    def won?
        if @secret_word == @game_word.split(" ").join
            print @game_word + "\n\n"
            print "You won!!!\n\n"
            return true
        end
    end

end