class Cell
  attr_reader :x, :y, :index

  def initialize(x, y, board_id)
    @x = x
    @y = y
    @index = Board.index(x, y)
    @color = nil
    @board_id = board_id
  end

  def set(color)
    raise index + ': This cell is already filled.' if filled?
    @color = color.to_sym
  end

  def reverse
    raise index + ': This cell is not filled.' unless filled?
    @color = white? ? :black : :white
  end

  def white?
    color == :white
  end

  def black?
    color == :black
  end

  def filled?
    !@color.nil?
  end

  def opposite_to?(color)
    filled? && @color != color
  end

  def vector_to(cell)
    Cell.vectors.each do |vector|
      if next_cell(vector) == cell
        return vector
      end
    end
  end

  def next_cell(vector)
    index = next_cell_index(vector)
    board.find index[0], index[1]
  end

  def board
    Board.instance(@board_id)
  end

  def color
    @color.to_sym if @color
  end

  def self.vectors
    %w(right left below above right-below right-above left-below left-above)
  end

  private

  def next_cell_index(vector)
    case vector
    when 'right'
      [@x + 1, @y]
    when 'left'
      [@x - 1, @y]
    when 'below'
      [@x, @y + 1]
    when 'above'
      [@x, @y - 1]
    when 'right-below'
      [@x + 1, @y + 1]
    when 'right-above'
      [@x + 1, @y - 1]
    when 'left-below'
      [@x - 1, @y + 1]
    when 'left-above'
      [@x - 1, @y - 1]
    end
  end
end
