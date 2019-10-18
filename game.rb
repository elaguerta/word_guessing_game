require 'httparty'
require 'byebug'

class Game
    attr_reader :secret_word, :game_word, :dictionary

    # Initialize: pull the dictionary from the REACH API. Pick a secret word at random from the dictionary
    # if it has not already been passed as an argument.
    # The secret word may be a phrase (string with spaces), and it may contain letters, numbers, and  
    def initialize(player, difficulty = nil, passed_word = nil)
        url = "http://app.linkedin-reach.io/words?"
        
        #set the difficulty, get the secret word or phrase
        if difficulty
            url += "difficulty=#{difficulty}"
        end
        response = HTTParty.get(url)
        @dictionary = response.parsed_response.split("\n")
        passed_word ||= dictionary.sample.downcase
        @secret_word = passed_word.downcase


        #initialize the list of players. Current player is the first player. 
        @players = [player]
        @curr_player_index = 0
        @curr_player = @players[@curr_player_index]
 
        print "Enter 1 for one player, or 2 for two player: "
        player_mode = gets.chomp
        if player_mode == "2"
            player_2 = Player.new("Player_2")
            @players += [player_2]
        end

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
        guess = @curr_player.get_guess
        if correct_guess?(guess)
            @curr_player.correct_guesses += [guess]
        else
            @curr_player.guesses_remaining -= 1
            @curr_player.incorrect_guesses += [guess]
        end
        puts "#{@curr_player.name}'s' incorrect guesses: #{@curr_player.incorrect_guesses}"
        puts "#{@curr_player.name}'s guesses remaining: #{@curr_player.guesses_remaining}"
        puts "#{@curr_player.name}'s available points: #{@curr_player.correct_guesses.length * @secret_word.length}"
        puts "#{@curr_player.name}'s flower: "
        puts File.read("flower#{@curr_player.guesses_remaining}.txt")
        puts "_____________________________________"
        puts "\n\n"
        @curr_player_index = (@curr_player_index + 1) % 2
        @curr_player = @players[@curr_player_index]
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
        if @players.any?{ |player| player.guesses_remaining == 0}
            puts "You lost. The secret word is: #{@secret_word}\n\n"
            return true
        end
    end

    def won?
        game_phrase = @game_word.split("  ")
        current_phrase = ""

        game_phrase.each do |word|
            current_phrase += word.split(" ").join + " "
        end

        if @secret_word == current_phrase[0...-1] #ignore last space in current phrase
            score = @curr_player.correct_guesses.length * @secret_word.length
            print @game_word + "\n\n"
            print "#{@curr_player.name} won!!! Score: #{score}\n\n"
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