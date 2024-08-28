require './tile'

class MineGame
  attr_accessor :is_lost
  attr_reader :id, :tiles

  def initialize(n)
    @id = rand(0..10_000) 
    @is_lost = false
    @tiles_visited = Hash.new
    make_map(n)
  end

  def make_map(n)
    @tiles = Array.new(n, 0) { Array.new(n, 0) }

    (0..n-1).each do |x|
      (0..n-1).each do |y|
        @tiles[x][y] = Tile.new(x, y, false, 0)
      end
    end
    
    minesPut = 0

    loop do
      x = rand(0..n-1)
      y = rand(0..n-1)

      if !@tiles[x][y].has_mine
        @tiles[x][y].has_mine = true
        minesPut += 1
      end
  
      break if minesPut == n * 2
    end

    @tiles.each do |row|
      row.each do |tile|
        calc_mines_around(tile)
      end
    end
  end

  def reveal_tile(x, y)
    return if @is_lost
  
    tile = @tiles[x][y]
    tile.is_revealed = true

    if tile.has_mine
      puts "Mine found at #{x}, #{y}"
      @is_lost = true

      @tiles.each do |row|
          row.each do |tile|
              tile.is_revealed = true
          end
      end
    end
  
    reveal_neighbour_tiles(tile)
  end

  def is_game_won
    @tiles.all? do |row|
      row.all? do |tile| 
        tile.is_revealed || tile.has_mine
      end
    end
  end

  def print_map()
    @tiles.each do |row|
      row.each do |tile|
        print "-  " if !tile.is_revealed
        print "x  ".red if tile.is_revealed && tile.has_mine
        print "#{tile.mines_around}  ".blue if tile.is_revealed
      end
      print "\n"
    end

    @tiles_visited.clear

  end

  def print_truth_map()
    @tiles.each do |row|
      row.each do |tile|
        print tile.has_mine ? "x  ".red : "#{tile.mines_around}  "
      end
      print "\n"
    end
  end

  private

  def calc_mines_around(tile)
    rows = @tiles.length - 1
    cols = @tiles[0].length - 1

    min_x = [tile.x - 1, 0].max
    max_x = [tile.x + 1, cols].min
    min_y = [tile.y - 1, 0].max
    max_y = [tile.y + 1, rows].min

    mines_found = 0

    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        next if x == @x && y == @y
        mines_found += 1 if @tiles[x][y].has_mine
      end
    end

    tile.mines_around = mines_found
  end

  def reveal_neighbour_tiles(tile)
    tile.is_revealed = true

    @tiles_visited[tile.x] ||= []
    @tiles_visited[tile.x].push(tile.y)

    return if tile.mines_around != 0

    rows = @tiles.length - 1
    cols = @tiles[0].length - 1
    min_x = [tile.x - 1, 0].max
    max_x = [tile.x + 1, rows].min
    min_y = [tile.y - 1, 0].max
    max_y = [tile.y + 1, cols].min

    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        @tiles_visited[x] ||= []

        next if x == tile.x && y == tile.y

        next if @tiles_visited[x].include?(y)

        neighbour_tile = @tiles[x][y]

        if neighbour_tile.mines_around == 0
          reveal_neighbour_tiles(neighbour_tile)
        else
          neighbour_tile.is_revealed = true
        end

      end
    end
  end
end
