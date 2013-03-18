require 'debugger'
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
    @NEIGHBORS = [[-1, 1], [0,1 ], [1,1 ],
                  [-1, 0], [0,0 ], [1,0 ],
                  [-1,-1], [0,-1], [1,-1]
                  ]
    build_board
  end

  def build_board
    @board = Array.new(@size) { Array.new(@size, 0) }
    assign_bombs

  end

  def assign_bombs
    @mines.times do
      assigned = false
      # debugger
      until assigned
        row, col = rand(@size), rand(@size)
        next if bomb?(row, col)
        add_bomb_n_adj(row, col)
        assigned = true
      end
    end
  end



  def add_bomb_n_adj(row,col)
    @board[row][col] = :bomb
    neighbors_of_rc = @NEIGHBORS.map {|r,c| [r+row,c+col] }
    neighbors_of_rc.each do |cell|
      next if @board[cell[0]][cell[1]].nil?
      @board[cell[0]][cell[1]] += 1 unless @board[cell[0]][cell[1]].bomb?
    end


  end

  def bomb?(row, col)
    return true if @board[row][col] == :bomb
    false
  end

end