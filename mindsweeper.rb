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

class Square

  attr_reader :pos, :bomb, :flag, :chosen

  NEIGHBORS = [
    [-1, -1],
    [-1, 0],
    [1,  1],
    [1,  0],
    [0,  1],
    [-1, 1],
    [1, -1],
    [0, -1]
  ]

  def initialize(pos, bomb, chosen = false, flag = false)
    @pos = pos
    @bomb =  bomb
    @chosen = chosen
    @flag = flag

  end

  def neighbor_squares
    neighbors = []
    NEIGHBORS.each do |(x, y)|
      if (pos[0] + x).between?(0,8) && (pos[1] + y).between?(0,8)
        neighbors << [pos[0] + x, pos[1] + y]
      end
    end
    neighbors
  end
end



board = Board.new
board.print_board

square = Square.new([0,0], true)

p square.neighbor_squares
