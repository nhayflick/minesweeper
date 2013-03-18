class Game

  def initialize(size, mines)
    @board = Board.new(mines)
  end

  #loops through the game until over
  def play

  end

end

class Board

  def initialize(size, mines)
    @size = size
    @mines = mines
    build_board
  end

  def build_board
    @board = Array.new(Array.new(nil, @size), @size)
    assign_bombs
  end

  def assign_bombs
    @mines.times do
      assigned = false
      until assigned
        row, col = rand(@size), rand(@size)
        next if bomb?
        add_bomb(row,col)
        assigned = true
      end
    end
  end

  def add_bomb(row,col)
    @board[row][col] =
  end

end