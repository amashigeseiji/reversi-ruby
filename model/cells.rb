class Cells < Hash
  def initialize(board_id)
    @board_id = board_id
    (1..8).each do |x|
      (1..8).each do |y|
        self[Cells.index(x, y)] = Cell.new(x, y, board_id)
      end
    end
  end

  def [](index)
    index = Cells.index(*index) if index.is_a? Array
    super(index)
  end

  def line(x)
    self.select { |i, cell| cell.x == x }
  end

  def row(y)
    self.select { |i, cell| cell.y == y }
  end

  def white
    select {|index, cell| cell.white? }
  end

  def black
    select {|index, cell| cell.black? }
  end

  def empties
    select {|key, cell| !cell.filled? }
  end

  def setup
    self[[4, 4]].set(:white)
    self[[5, 4]].set(:black)
    self[[5, 5]].set(:white)
    self[[4, 5]].set(:black)
  end

  def self.index(x, y)
    x.to_s + '_' + y.to_s
  end
end
