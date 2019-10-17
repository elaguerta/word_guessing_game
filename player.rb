class Player
    attr_reader :name, :incorrect_guesses, :guesses_remaining, :correct_guesses
    attr_writer :guesses_remaining, :incorrect_guesses, :correct_guesses

    def initialize(name)
        @name = name
        @guesses_remaining = 6
        @incorrect_guesses = []
        @correct_guesses = []
    end

    def get_guess
        print "Guess a letter: "
        guess = gets.chomp
        if valid_guess?(guess)
            return guess
        else
            self.get_guess
        end
    end

    def valid_guess?(guess)
        if !guess.match?(/\A[a-zA-z]\z/)
            puts "Not a letter! Guess again."
            return false
        elsif @incorrect_guesses.include?(guess) || @correct_guesses.include?(guess)
            puts "You already guessed that letter. Guess again.\n\n"
            return false
        else
            return true
        end
    end

end