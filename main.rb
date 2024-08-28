require 'colorize'
require './tile'
require './mine_game'

def main
  game = MineGame.new(10)

  until game.is_lost do 
    game.print_map
    coords = gets.chomp.split(",")
    x = coords[0].to_i
    y = coords[1].to_i
    game.reveal_tile(x, y)
  end

  game.print_truth_map
end

main