class Cell
  attr_reader :x, :y, :index

  def initialize(x, y, game_id)
    @x = x
    @y = y
    @index = Cells.index(x, y)
    @color = nil
    @game_id = game_id
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
    game.cells[next_cell_index(vector)]
  end

  def game
    Game.instance(@game_id)
  end

  def color
    @color.to_sym if @color
  end

  def self.vectors
    %w(right left below above right-below right-above left-below left-above)
  end

  def to_hash
    { x: @x, y: @y, index: @index, color: @color }
  end

  def corner?
    ['A1', 'A8', 'H1', 'H8'].include? @index
  end

  def wall?
    @x == 1 || @x == 8 || @y == 1 || @y == 8
  end

  def next_corner?
    ['A2', 'A7', 'B1', 'B2', 'B7', 'B8', 'G1', 'G2', 'G7', 'G8', 'H2', 'H7'].include? @index
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
