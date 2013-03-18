require 'debugger'
class Game

  def initialize(size, mines)
    @board = Board.new(size, mines)
  end

  #loops through the game until over
  def play

    until over?
      puts "Please enter your move: (h for help)"

      prompt(gets.chomp)

    end

  end

  def prompt(input)
    input = input.split.map(&:downcase)
    input[1..2].map!(&:to_i)
    if input[0][0] == 'h'
      puts "Enter your move as 'Reveal row column' or "
      puts "Enter your move as 'Flag row column' "
      puts "Enter 'q' to quit"
      return
    elsif valid_move?(input)
      # input = ['Flag', 3, 4]
      make_move(input)
    elsif input[0][0] == 'q'
      puts "Too tough for ya?"
      exit
    else
      puts "Please enter valid move."
    end

  end


  def valid_move?(input)
      (input[0][0] == 'r' || 'f' ) && (0..(Board.size-1)).include?(input[1]) && (0..(Board.size-1)).include?(input[2])
  end

  def over?
    # boolean to check if game over
    # all non-bomb squares revealed or bomb explode
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
    # :b, or [1-8], or 0
    assign_bombs
    @board_reveal = Array.new(@size) { Array.new(@size, false) }
    # just true or false
    @board_flag = []
    # just indices (ie [[1,2], [4,5]])
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
    @board[row][col] = :b
    neighbors_of_rc = @NEIGHBORS.map {|r,c| [r+row,c+col] }
    neighbors_of_rc.each do |cell|
      next if @board[cell[0]].nil? || @board[cell[0]][cell[1]].nil?
      @board[cell[0]][cell[1]] += 1 unless bomb?(cell[0],cell[1])
    end

  end

  def bomb?(row, col)
    return true if @board[row][col] == :b
    false
  end

  def print
    print_board = Array.new(@size) { Array.new(@size, '*') }
    @board.each_with_index do |row, r_i|
      row.each_with_index do |element, c_i|
        if @board_reveal[r_i][c_i]
          print_board[r_i][c_i] = element
          print_board[r_i][c_i] = '_' if @board[r_i][c_i] == 0
        end
      end
    end
  print_board
  end

end