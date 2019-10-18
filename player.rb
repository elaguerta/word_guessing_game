class Player

    #The Game class will update the Player's @guesses_reamaining, @incorrect_guesses, and @correct_guesses.
    attr_reader :name, :incorrect_guesses, :guesses_remaining, :correct_guesses
    attr_writer :guesses_remaining, :incorrect_guesses, :correct_guesses

    def initialize(name)
        @name = name
        @guesses_remaining = 6
        @incorrect_guesses = []
        @correct_guesses = []
    end

    def get_difficulty
        print "Choose a difficulty level from 1 (easiest) to 10 (hardest): "
        level = gets.chomp.to_i
        if (1..10).include? level
            return level
        else
            puts "Not a valid difficulty level! Choose again.\n\n"
            self.get_difficulty
        end
    end

    #Ask the player for a valid guess. If it's not valid, ask again.
    def get_guess
        print "Enter 1 to guess a letter, or 2 to guess a word: "
        choice = gets.chomp.downcase
        if choice == "1"
            print "Guess a letter: "
            guess = gets.chomp.downcase
            if valid_letter_guess?(guess)
                return guess
            else
                self.get_guess
            end
        elsif choice == "2"
            print "Guess a word: "
            guess = gets.chomp.downcase
            if valid_word_guess?(guess)
                return guess
            else
                self.get_guess
            end
        end
    end

    #Valid guesses are letters that have not been guessed before. 
    def valid_letter_guess?(guess)
        if !guess.match?(/\A([a-z]|[-]|\d)\z/)
            puts "Not a letter! Guess again."
            return false
        elsif @incorrect_guesses.include?(guess) || @correct_guesses.include?(guess)
            puts "You already guessed that letter. Guess again.\n\n"
            return false
        else
            return true
        end
    end

    #Valid word guesses are words made of two or more letters that have not been guessed before. 
    def valid_word_guess?(guess)
        if !guess.match?(/\A([a-z]|[-]|\d){2,}\z/)       #(/\A[a-z]{2,}\z/)
            puts "Not a legal word guess! Guess again."
            return false
        elsif @incorrect_guesses.include?(guess) || @correct_guesses.include?(guess)
            puts "You already guessed that word. Guess again.\n\n"
            return false
        else
            return true
        end
    end

end