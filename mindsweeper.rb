class Board

  attr_accessor :height, :width, :bombs, :board, :display_board

  def initialize(height=9, width=9, bombs=10)
    @height = height
    @width = width
    @bombs = bombs
    @board = make_board
    @display_board = []
  end

  def square_by_index(pos)
    neighbor = board[pos[0]][pos[1]]
  end

  def make_board
    self.board = Array.new(height) {Array.new(width)}
    9.times do |i|
      9.times do |j|
        board[i][j] = Square.new([i,j])
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
    square.set_number(near_bombs)


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

      p adjacent_bombs(neighbor)
      next if adjacent_bombs(neighbor) > 0
      neighbors.concat(neighbor.neighbor_squares)

    end
    checked_squares
  end



  def print_board
    self.display_board = Array.new(height) {Array.new(width)}
    board.each do |line|
      line.each_with_index do |el, idx|

        if el.revealed
          self.display_board[el.pos[0]][el.pos[1]] = el.get_number
        elsif el.flagged
          self.display_board[el.pos[0]][el.pos[1]] = 'F'
        else
          self.display_board[el.pos[0]][el.pos[1]] = el.bomb
        end
      end
    end

    display_board.each { |line| p line }
  end





  def reveal_at_pos(pos)
    square_by_index(pos).reveal
    p square_by_index(pos)
  end


  def flag_at_pos(pos)
    square_by_index(pos).toggle_flag
    p square_by_index(pos)
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

  attr_accessor :pos, :bomb, :flagged, :revealed, :number, :board

  def initialize(pos, board=nil)
    @pos = pos
    @bomb =  false
    @revealed = false
    @flagged = false
    #@number = board.adjacent_bombs(self) if board
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



  def set_number(near_bombs)
    @number = near_bombs
  end

  def get_number
    @number
  end



  def reveal
    self.revealed = true
  end


  def toggle_flag
    unless self.revealed
      if self.flagged
        self.flagged = false
      else
        self.flagged = true
      end
    end
  end
end






board = Board.new
board.print_board

square = Square.new([0,0], board)

board.reveal_at_pos(square.pos)
board.flag_at_pos(square.pos)
board.reveal_at_pos([1,0])
board.flag_at_pos([0,1])

p board.adjacent_bombs(square)
p board.check_neighbors(square)


board.print_board
