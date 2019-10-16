class Player
    attr_reader :name, :incorrect_guesses, :guesses_remaining
    attr_writer :guesses_remaining, :incorrect_guesses

    def initialize(name)
        @name = name
        @guesses_remaining = 6
        @incorrect_guesses = []
    end

    def get_guess
        puts "Guess a letter."
        guess = gets.chomp
        if valid_guess?(guess)
            return guess
        else
            puts "Not a letter! Guess again."
            self.get_guess
        end
    end

    def valid_guess?(guess)
       guess.match?(/\A[a-zA-z]\z/)
    end

end