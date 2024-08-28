class Tile
  attr_reader :x, :y
  attr_accessor :has_mine, :is_revealed, :mines_around

  def initialize(x, y, has_mine, mines_around)
    @x = x
    @y = y
    @has_mine = has_mine
    @mines_around = mines_around 
    @is_revealed = false
  end

end
