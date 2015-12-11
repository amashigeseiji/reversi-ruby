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

  def vector_to(cell)
    %w(right left below above right.below right.above left.below left.above).each do |vector|
      if instance_eval(vector) == cell
        return vector
      end
    end
  end

  def right
    board.find(@x + 1, @y)
  end

  def left
    board.find(@x - 1, @y)
  end

  def below
    board.find(@x, @y + 1)
  end

  def above
    board.find(@x, @y - 1)
  end

  def board
    @board ||= Board.instance(@board_id)
  end

  def method_missing(name, *args, &block)
    methods = name.to_s.split('.')
    cell = nil
    methods.each do |method|
      unless cell
        cell = send(method) if %w(right left below above).include?(method)
      else
        cell = cell.send(method)
      end
    end
    cell
  end

  def color
    @color.to_sym if @color
  end
end
