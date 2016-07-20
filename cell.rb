# A class that represents an individual cell in the minefield.
class Cell
  attr_accessor :place_mines, :mine

  def initialize
    @mine = false
    @revealed = false
  end

  def place_mines
    @mine = true
  end

  def contains_mine?
    @mine
  end

  def reveal!
    @revealed = true
  end

  def revealed?
    @revealed
  end
end
