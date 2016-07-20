require_relative "cell"
require "pry"

class Minefield
  attr_reader :row_count, :column_count, :field

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count

    build_minefield
    plant_mines
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @field[row][col].revealed?
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    if !@field[row][col].contains_mine?
      @field[row][col].reveal!
      if row == 0 && col == 0
        if !@field[row][col + 1].contains_mine? && !@field[row + 1][col].contains_mine? && !@field[row + 1][col + 1].contains_mine?
           @field[row][col + 1].reveal!
           @field[row + 1][col].reveal!
           @field[row + 1][col + 1].reveal!
         end
      elsif row == 0 && col == @column_count - 1
        if !@field[row][col - 1].contains_mine? && !@field[row + 1][col - 1].contains_mine? && !@field[row + 1][col].contains_mine? &&
           @field[row][col - 1].reveal!
           @field[row + 1][col - 1].reveal!
           @field[row + 1][col].reveal!
         end
      elsif row == @row_count - 1 && col == 0
        if !@field[row][col + 1].contains_mine? && !@field[row - 1][col + 1].contains_mine? && !@field[row - 1][col].contains_mine? &&
           @field[row][col + 1].reveal!
           @field[row - 1][col + 1].reveal!
           @field[row - 1][col].reveal!
         end
      elsif row == @row_count - 1 && col == @column_count - 1
        if !@field[row][col - 1].contains_mine? && !@field[row - 1][col - 1].contains_mine? && !@field[row - 1][col].contains_mine? &&
           @field[row][col - 1].reveal!
           @field[row - 1][col - 1].reveal!
           @field[row - 1][col].reveal!
         end
      elsif row == 0
        if !@field[row][col - 1].contains_mine? && !@field[row][col + 1].contains_mine? && !@field[row + 1][col - 1].contains_mine? && !@field[row + 1][col].contains_mine? && !@field[row + 1][col + 1].contains_mine? &&
           @field[row][col - 1].reveal!
           @field[row][col + 1].reveal!
           @field[row + 1][col - 1].reveal!
           @field[row + 1][col].reveal!
           @field[row + 1][col + 1].reveal!
         end
      elsif col == 0
        if !@field[row - 1][col].contains_mine? && !@field[row - 1][col + 1].contains_mine? && !@field[row][col + 1].contains_mine? && !@field[row - 1][col].contains_mine? && !@field[row - 1][col + 1].contains_mine? &&
           @field[row - 1][col].reveal!
           @field[row - 1][col + 1].reveal!
           @field[row][col + 1].reveal!
           @field[row - 1][col].reveal!
           @field[row - 1][col + 1].reveal!
         end
      elsif row == @row_count - 1
        if !@field[row][col - 1].contains_mine? && !@field[row][col + 1].contains_mine? && !@field[row - 1][col - 1].contains_mine? && !@field[row - 1][col].contains_mine? && !@field[row - 1][col + 1].contains_mine? &&
           @field[row][col - 1].reveal!
           @field[row][col + 1].reveal!
           @field[row - 1][col - 1].reveal!
           @field[row - 1][col].reveal!
           @field[row - 1][col + 1].reveal!
         end
      elsif col == @column_count - 1
        if !@field[row - 1][col].contains_mine? && !@field[row - 1][col - 1].contains_mine? && !@field[row][col - 1].contains_mine? && !@field[row - 1][col].contains_mine? && !@field[row - 1][col - 1].contains_mine? &&
           @field[row - 1][col].reveal!
           @field[row - 1][col - 1].reveal!
           @field[row][col - 1].reveal!
           @field[row - 1][col].reveal!
           @field[row - 1][col - 1].reveal!
         end
      elsif row > 0 && row < @row_count && col > 0 && col < @column_count
          adjacent_cells(row, col).each do |cell|
           if !cell.contains_mine?
             cell.reveal!
           end
         end
       end
     else @field[row][col].reveal!
    end
  end

  def adjacent_cells(row, col)
    [ @field[row - 1][col - 1],
      @field[row - 1][col],
      @field[row - 1][col + 1],
      @field[row][col - 1],
      @field[row][col + 1],
      @field[row + 1][col - 1],
      @field[row + 1][col],
      @field[row + 1][col + 1]]
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    @field.flatten.each do |cell|
      if cell.mine == true && cell.revealed?
        return true
      end
    end
    return false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    @field.flatten.each do |cell|
      if cell.mine == false && !cell.revealed?
        return false
      end
    end
    return true
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    count = 0
    if @field[row + 1].nil? && @field[row][col + 1].nil?
      count = 0
      count += 1 if @field[row - 1][col - 1].contains_mine?
      count += 1 if @field[row - 1][col].contains_mine?
      count += 1 if @field[row][col - 1].contains_mine?
    elsif @field[row + 1].nil? && @field[row][col - 1].nil?
      count = 0
      count += 1 if @field[row - 1][col + 1].contains_mine?
      count += 1 if @field[row - 1][col].contains_mine?
      count += 1 if @field[row][col + 1].contains_mine?
    elsif @field[row - 1].nil? && @field[row][col + 1].nil?
      count = 0
      count += 1 if @field[row + 1][col - 1].contains_mine?
      count += 1 if @field[row + 1][col].contains_mine?
      count += 1 if @field[row][col - 1].contains_mine?
    elsif @field[row - 1].nil? && @field[row][col - 1].nil?
      count = 0
      count += 1 if @field[row + 1][col + 1].contains_mine?
      count += 1 if @field[row + 1][col].contains_mine?
      count += 1 if @field[row][col + 1].contains_mine?
    elsif @field[row - 1].nil?
      count = 0
      count += 1 if @field[row][col - 1].contains_mine?
      count += 1 if @field[row][col + 1].contains_mine?
      count += 1 if @field[row + 1][col - 1].contains_mine?
      count += 1 if @field[row + 1][col].contains_mine?
      count += 1 if @field[row + 1][col + 1].contains_mine?
    elsif @field[row + 1].nil?
      count = 0
      count += 1 if @field[row - 1][col - 1].contains_mine?
      count += 1 if @field[row - 1][col].contains_mine?
      count += 1 if @field[row - 1][col + 1].contains_mine?
      count += 1 if @field[row][col - 1].contains_mine?
      count += 1 if @field[row][col + 1].contains_mine?
    elsif @field[row][col + 1].nil?
      count = 0
      count += 1 if @field[row - 1][col - 1].contains_mine?
      count += 1 if @field[row - 1][col].contains_mine?
      count += 1 if @field[row][col - 1].contains_mine?
      count += 1 if @field[row + 1][col - 1].contains_mine?
      count += 1 if @field[row + 1][col].contains_mine?
    elsif @field[row][col - 1].nil?
      count = 0
      count += 1 if @field[row - 1][col + 1].contains_mine?
      count += 1 if @field[row - 1][col].contains_mine?
      count += 1 if @field[row][col + 1].contains_mine?
      count += 1 if @field[row + 1][col + 1].contains_mine?
      count += 1 if @field[row + 1][col].contains_mine?
    else
      count = 0
      adjacent_cells(row, col).each do |cell|
       if cell.contains_mine?
         count += 1
       end
     end
    end
    count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @field[row][col].contains_mine?
  end

  private

  # Create a data structure within an instance variable that will represent
  # the minefield.
  def build_minefield
    @field = []
    @row_count.times do
      row = []
      @column_count.times do
        row << Cell.new
      end
      @field << row
    end
  end

  # Distribute mines amongst the individual minefield cells
  def plant_mines
    row_count = @field.length
    cell_count =  @field[0].length
    @mine_count.times do |plant|
      row_index = rand(row_count)
      cell_index = rand(cell_count)
        if @field[row_index][cell_index].mine = false
          @field[row_index][cell_index].place_mines
        else
          @field[rand(row_count)][rand(cell_count)].place_mines
        end
      end
    @field
  end
end
