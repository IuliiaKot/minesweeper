class Board

  attr_accessor :height, :width, :bombs, :board, :display_board, :checked_squares

  def initialize(height=9, width=9, bombs=10)
    @height = height
    @width = width
    @bombs = bombs
    @board = make_board
    @display_board = []
    @checked_squares = []
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

    valid_bombs = []
    until valid_bombs.length == 10
      x = rand(0..8)
      y = rand(0..8)
      next if valid_bombs.include?([x,y])
      valid_bombs << [x,y]
      board[x][y].bomb = true
    end
    board
  end


  # def adjacent_bombs(square)
  #   neighbors = square.neighbor_squares
  #   near_bombs = 0
  #   neighbors.each do |(x, y)|
  #     near_bombs += 1 if square_by_index([x, y]).bomb
  #   end
  #
  #   near_bombs
  # end


  def check_neighbors(square)
    @checked_squares << square
    return @checked_squares if square.adjacent_bombs(self) > 0
    neighbors = square.neighbor_squares

    until neighbors.empty?
      neighbor_pos = neighbors.shift
      neighbor = square_by_index(neighbor_pos)
      next if @checked_squares.include?(neighbor)
      @checked_squares << neighbor


      next if neighbor.adjacent_bombs(self) > 0
      neighbors.concat(neighbor.neighbor_squares)

    end

    @checked_squares

  end


  def reveal_squares
    @checked_squares.each do |square|
      square.reveal

    end
  end




  def print_board(dead = nil)
    self.display_board = Array.new(height) {Array.new(width)}

    reveal_squares

    board.each do |line|
      line.each_with_index do |el, idx|

        if el.revealed
          self.display_board[el.pos[0]][el.pos[1]] = el.number
        elsif el.flagged
          self.display_board[el.pos[0]][el.pos[1]] = 'F'
        else
          self.display_board[el.pos[0]][el.pos[1]] = "*"
        end
        if dead
          if el.bomb
            self.display_board[el.pos[0]][el.pos[1]] = 'B'
          end
        end
      end
    end

    columns = [1,2,3,4,5,6,7,8,9]
    p  '   ' + columns.join(' ')

    display_board.each_with_index do |line, row|
      p "#{row + 1}: " + line.join(' ')
    end
  end





  def reveal_at_pos(pos)
    square_by_index(pos).reveal
  end


  def flag_at_pos(pos)
    square_by_index(pos).toggle_flag
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
    @bombed = false
    #@number = board.adjacent_bombs(self) if board
  end



  def bombed
    @bombed = true
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


  def adjacent_bombs(board)
    neighbors = neighbor_squares
    near_bombs = 0
    neighbors.each do |(x, y)|

      near_bombs += 1 if board.square_by_index([x, y]).bomb
    end
    @number = near_bombs
    near_bombs
  end



  def reveal
    unless self.flagged
      self.revealed = true
    end
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

class PlayGame

  attr_accessor :board, :bombs, :flags

  def initialize
    @board = Board.new()
    @bombs = board.bombs
    @flags = @bombs


  end

  def pick_square
    while true
      puts "Pick a square"
      pos = gets.chomp.split(',')
      pos.each_with_index {|i, j| pos[j] = (i.to_i - 1)}
      begin
        unless pos[0].between?(0,8) && pos[1].between?(0,8)
          puts "Please pick square between 1 and 9"
          next
        end
      rescue
        next
      end

      if board.square_by_index(pos).revealed
        puts "That square is already opened. Please pick another one."
        next
      end
      break
    end
    pos
  end


  def flag_or_reveal
    while true
      puts "Press f to set a flag or r to reveal"
      action = gets.chomp.downcase
      unless action == 'f' || action =='r'
        next
      end
      if action = 'f' && flags < 1
        unless @square.flagged
          puts "You don't have any flags left. Please pick one up"
          @square = board.square_by_index(pick_square)
          next
        end
      end


      break
    end
    action
  end

  def win?
    count = 0
    current_board = board.board
    current_board.each do |line|
      line.each do |tile|
        if tile.bomb && tile.flagged
          count += 1
        end
      end
    end
    count == bombs
  end




  def play()
    while true
      puts "You have #{flags} left."
      board.print_board
      puts
      pos = pick_square
      @square = board.square_by_index(pos)
      action = flag_or_reveal

      if action == 'r'
        break if square.bomb
        board.check_neighbors(@square)
      else
        @square.toggle_flag
        if @square.flagged == false
          @flags += 1
        else
        @flags -= 1
        end
      end

      if win?
        puts "You win!"
        return board.print_board
      end
    end
    puts "Sorry, you're dead"
    board.print_board(true)
  end

end



board = Board.new
#board.print_board

square = Square.new([0,0], board)

game = PlayGame.new

game.play
#
# board.reveal_at_pos(square.pos)
# #board.flag_at_pos(square.pos)
# #board.reveal_at_pos([1,1])
# #board.flag_at_pos([0,1])
#
# #board.adjacent_bombs(square)
# square.adjacent_bombs(board)
#board.check_neighbors(square)
#
#
 #board.print_board
