require 'debugger'
require 'JSON'
class Game
  attr_accessor :board
  def initialize(size, mines)
    @board = Board.new(size, mines)
  end

  #loops through the game until over
  def play

    until won?
      @board.print

      puts "Please enter your move: (h for help)"

      input = prompt(gets.chomp)

      next if input.nil?

      make_move(input)
      @time  ||= Time.now
      @moves ||= 0
      @moves  += 1



    end
    @board.print
    puts "YOU WON!!!"
    @time = (Time.now - @time).to_i
    puts "You completed the game in #{@time} seconds and #{@moves} moves!"
    file = File.read('highscores.json')
    json = JSON.parse(file) unless file.empty?
    json ||= {}
    json['highscores'] ||= []
    json['highscores'] << [@time, @moves]
    puts json
    File.open('highscores.json', 'w') do |file|
      file.write(json.to_json)
    end
  end

  def make_move(input)
    # input = ['reveal',4,5]
    row, col = input[1], input[2]
    if input[0][0] = 'r'
      if @board.bomb?(row,col)
        puts "KABOOM!"
        exit
      else
        @board.board_reveal[row][col] = true
      end
    else
      # it has to be flag
      unless @board.board_flag.include?([row,col])
        @board.board_flag << [row,col]
      else
        @board.board_flag.delete([row,col])
      end
    end
  end


  def prompt(input)
    input = input.split(' ').map(&:downcase)
    input[1],input[2] = input[1..2].map!(&:to_i)
    if input[0][0] == 'h'
      puts "Enter your move as 'Reveal row column' or "
      puts "Enter your move as 'Flag row column' "
      puts "Enter 'q' to quit"
      return nil
    elsif valid_move?(input)
      return input
    elsif input[0][0] == 'q'
      puts "Too tough for ya?"
      exit
    else
      puts "Please enter valid move."
      p input
      return nil
    end
  end


  def valid_move?(input)
      (input[0][0] == 'r' || input[0][0] == 'f' ) && (0..(@board.size-1)).include?(input[1]) && (0..(@board.size-1)).include?(input[2])
  end

  def won?
    return true if @board.board_reveal.flatten.select{|bool| bool == false }.length == @board.mines
    false
  end

end

class Board

  attr_accessor :size, :board_reveal, :board_flag, :mines

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
      next if cell[0] < 0  || cell[1] < 0
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
          print_board[r_i][c_i] = 'F' if @board_flag.include?([[r_i],[c_i]])
          print_board[r_i][c_i] = '_' if @board[r_i][c_i] == 0
        end
      end
    end
    puts (" " * 20) + ( "_" * (10+@size) )
    print_board.each do |line|
      puts (" " * 20) + "|" + line.join(" ") + "|"
    end
    puts (" " * 20 ) + "_" * (10+@size)
  end

end