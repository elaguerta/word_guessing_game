require_relative "game"
require_relative "player"

player_1 = Player.new("player_1")
word_game = Game.new(player_1)

while !word_game.game_over?
    word_game.play_round
end
