class Board

  attr_reader :height, :width, :bombs, :board

  def initialize(height=9, width=9, bombs=10)
    @height = height
    @width = width
    @bombs = bombs
    @board = make_board
  end



  def make_board
    board = Array.new(height) {Array.new(width, '*')}
    10.times do |i|
      x = rand(0..8)
      y = rand(0..8)
      board[x][y] = "b"
    end
    board
  end

  def print_board
    board.each do |line|
      p line.join(' ')
    end
  end
end

board = Board.new
board.print_board
