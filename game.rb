require 'httparty'


class Game
    attr_reader :secret_word, :guessed_words, :guesses_remaining

    def initialize(passed_word = nil)
        url = "http://app.linkedin-reach.io/words"
        response = HTTParty.get(url)
        dictionary = response.parsed_response.split("\n")
        passed_word ||= dictionary.sample

        @secret_word = passed_word
        @guesses_remaining = 6
        @guessed_words = []
        @word = '_ '* @secret_word.length 
    end

    def turn
        
    end
end