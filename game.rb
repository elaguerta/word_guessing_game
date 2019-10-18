require 'httparty'
require 'byebug'

class Game
    attr_reader :secret_word, :game_word, :dictionary

    # Initialize: pull the dictionary from the REACH API. Pick a secret word at random from the dictionary
    # if it has not already been passed as an argument.
    # The secret word may be a phrase (string with spaces), and it may contain letters, numbers, and  
    def initialize(player, difficulty = nil, passed_word = nil)
        url = "http://app.linkedin-reach.io/words?"
        
        if difficulty
            url += "difficulty=#{difficulty}"
        end

        response = HTTParty.get(url)
        @dictionary = response.parsed_response.split("\n")
        passed_word ||= dictionary.sample.downcase

        @secret_word = passed_word.downcase
        @player = player 

        @game_word = ""
        @secret_word.each_char do |char|
            add_char = "_"
            if char == " "
                add_char = " "
            end
            @game_word += add_char + " "
        end
        
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
        puts File.read("flower#{@player.guesses_remaining}.txt")
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
            phrase = @secret_word.split(" ")
            game_phrase = @game_word.split("  ")

            if phrase.include?(guess)
                puts "That word is correct!"
                phrase.each_with_index do |word,idx|
                    if word == guess
                        game_phrase[idx] = guess.split("").join(" ")
                        @game_word = game_phrase.join("  ")
                    end
                end
            else
                puts "That word is not a correct guess."
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
        debugger
        game_phrase = @game_word.split("  ")
        current_phrase = ""

        game_phrase.each do |word|
            current_phrase += word.split(" ").join + " "
        end

        if @secret_word == current_phrase[0...-1] #ignore last space in current phrase
            score = @player.guesses_remaining * @secret_word.length
            print @game_word + "\n\n"
            print "You won!!! Score: #{score}\n\n"
            self.add_to_leaderboard(score)
            return true
        end
    end

    def add_to_leaderboard(score)
        count = 0
        leaderboard = []

        File.foreach("leaderboard.txt") do |line| 
            if count < 4
                leaderboard += [line]
            else
                break
            end
            count += 1
        end

        leaderboard.each_with_index do |line, idx|
            this_score = line.split(" ")[1].to_i
            if score > this_score
                print "You made it to the leaderboard! Enter your initials: "
                player_handle = gets.chomp
                leaderboard[idx] = "#{player_handle} #{score}\n"
                break
            end
        end
        puts leaderboard.join
        File.write("leaderboard.txt", leaderboard.join)
    end

    def clear_leaderboard
        File.write("leaderboard.txt", "name 0\n"*4)
    end

end