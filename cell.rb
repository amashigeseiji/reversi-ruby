class Cell
  attr_reader :color, :x, :y, :index

  def initialize(x, y)
    @x = x
    @y = y
    @index = Board.index(x, y)
    @color = nil
  end

  def set(color)
    raise index + ': This cell is already filled.' if filled?
    @color = color
  end

  def reverse
    raise index + ': This cell is not filled.' unless filled?
    @color = white? ? :black : :white
  end

  def white?
    @color == :white
  end

  def black?
    @color == :black
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
    Board.instance.find(@x + 1, @y)
  end

  def left
    Board.instance.find(@x - 1, @y)
  end

  def below
    Board.instance.find(@x, @y + 1)
  end

  def above
    Board.instance.find(@x, @y - 1)
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
end
