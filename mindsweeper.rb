class Board

  attr_reader :height, :width, :bombs, :board

  def initialize(height=9, width=9, bombs=10)
    @height = height
    @width = width
    @bombs = bombs
    @board = make_board
  end

  def make_board
    board = Array.new(height) {Array.new(width)}

    9.times do |i|
      9.times do |j|
        board[i][j] = Square.new([i,j])
        #p Square.new([i,j])
      end
    end

    10.times do |i|
      x = rand(0..8)
      y = rand(0..8)
      board[x][y].bomb = true
    end

   board
  end

  def adjacent_bombs(square)
    neighbors = square.neighbor_squares
    near_bombs = 0
    neighbors.each do |(x, y)|
    near_bombs += 1 if board[x][y].bomb
    end
    near_bombs
  end

  def check_neighbors(square)
    return [] if adjacent_bombs(square) > 0
    neighbors = square.neighbor_squares
    checked_squares = []

    until neighbors.empty?
      neighbor_pos = neighbors.shift
      neighbor = square_by_index(neighbor_pos)
      next if checked_squares.include?(neighbor)
      checked_squares << neighbor

      next if adjacent_bombs(neighbor) > 0
      neighbors.concat(neighbor.neighbor_squares)

    end
    checked_squares
    # checked_squares.each do |line|
    #     p line.pos
    #   end
  end


  def square_by_index(pos)
    neighbor = board[pos[0]][pos[1]]

  end

  def print_board
    display_board = Array.new(height) {Array.new(width)}
    board.each do |line|
      line.each_with_index do |pos, idx|
        display_board[pos.pos[0]][pos.pos[1]] = pos.bomb
      end
    end
    display_board.each { |line| p line }
  end


end

class Square
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

  attr_accessor :pos, :bomb, :flag, :chosen, :number

  def initialize(pos, board=nil)
    @pos = pos
    @bomb =  false
    @chosen = false
    @flag = false
    @number = board.adjacent_bombs(self) if board
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

square = Square.new([0,0], board)

p board.adjacent_bombs(square)

p board.check_neighbors(square)
