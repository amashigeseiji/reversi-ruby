class Cells < Hash
  def initialize(board_id)
    @board_id = board_id
    (1..8).each do |x|
      (1..8).each do |y|
        self[Cells.index(x, y)] = Cell.new(x, y, board_id)
      end
    end
  end

  def cell(x, y)
    index = Cells.index(x, y)
    self.key?(index) ? self[index] : nil
  end

  def line(x)
    self.select { |i, cell| cell.x == x }
  end

  def row(y)
    self.select { |i, cell| cell.y == y }
  end

  def setup
    cell(4, 4).set(:white)
    cell(5, 4).set(:black)
    cell(5, 5).set(:white)
    cell(4, 5).set(:black)
  end

  def self.index(x, y)
    x.to_s + '_' + y.to_s
  end
end
