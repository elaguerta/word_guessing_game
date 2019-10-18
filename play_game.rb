require_relative "game"
require_relative "player"

player_1 = Player.new("Player_1")
puts "Welcome to the Word Guessing Game, where if you lose, you get an ASCII Flower."
difficulty = player_1.get_difficulty

#The Game class takes a difficulty level and an optional secret word.
#If you don't provide the secret word, a random one will be chosen from the dictionary. 
word_game = Game.new(player_1, difficulty)

while !word_game.game_over?
    word_game.play_round
end

#word_game.clear_leaderboard
