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
        if @secret_word.include?(guess)
            puts "That letter is in the secret word!"
            puts "Incorrect guesses: #{@player.incorrect_guesses}"
            puts "Guesses remaining: #{@player.guesses_remaining}"
            @player.correct_guesses += [guess]
            (0..@secret_word.length).each do |index|
                if @secret_word[index] == guess
                    @game_word[index * 2] = guess
                end
            end
        else
            puts "That letter is not in the secret word."
            @player.guesses_remaining -= 1
            @player.incorrect_guesses += [guess]
            puts "Incorrect guesses: #{@player.incorrect_guesses}"
            puts "Guesses remaining: #{@player.guesses_remaining}"
        end
        puts "_____________________________________"
        puts "\n\n"
    end

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