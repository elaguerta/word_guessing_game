require 'httparty'


class Game
    attr_reader :secret_word, :game_word

    def initialize(player, passed_word = nil)
        url = "http://app.linkedin-reach.io/words"
        response = HTTParty.get(url)
        dictionary = response.parsed_response.split("\n")
        passed_word ||= dictionary.sample

        @secret_word = passed_word
        @game_word = '_ '* @secret_word.length
        @player = player 
    end

    def play_round
        puts @game_word + "\n\n"
        guess = @player.get_guess[0]
        try_guess = @secret_word.index(guess)
        if try_guess
            @game_word[try_guess * 2] = guess
        else
            puts "That letter is not in the secret word."
            @player.guesses_remaining -= 1
            @player.incorrect_guesses += [guess]
            puts "Incorrect guesses: #{@player.incorrect_guesses}"
            puts "Guesses remaining: #{@player.guesses_remaining}"
            puts "\n\n"
        end
    end

    def game_over?
        self.lost? || self.won?
    end

    def lost?
        @player.guesses_remaining == 0
    end

    def won?
        @secret_word == @game_word
    end
end