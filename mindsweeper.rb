class Board

  attr_reader :height, :width, :bombs

  def initialize(height=9, width=9, bombs=10)
    @height = height
    @width = width
    @bombs = bombs
  end



  def make_board
    board = Array.new(height) {Array.new(width)}


    board[1][2] = "hey"
    board[0][0] = "hello"

    p board
  end
end

board = Board.new

board.make_board
