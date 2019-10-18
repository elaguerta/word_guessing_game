require_relative "game"
require_relative "player"

player_1 = Player.new("player_1")

#The Game class takes an optional secret word as the second parameter.
#If you don't provide the secret word, a random one will be chosen from the dictionary. 

word_game = Game.new(player_1, "hello")

while !word_game.game_over?

    word_game.play_round

end
