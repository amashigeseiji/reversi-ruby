class Board
  @@boards = {}
  attr_reader :data, :id

  def initialize(id = nil)
    @data = Resource.find(id)
    @id = @data.id
    setup unless @data.exist?
    @@boards[@id] = self
  end

  def setup
    create
    find(4, 4).set(:white)
    find(5, 4).set(:black)
    find(5, 5).set(:white)
    find(4, 5).set(:black)
    self
  end

  def cells
    @data.cells
  end

  def find(x, y)
    index = Board.index(x, y)
    @data.cells.key?(index) ? @data.cells[index] : nil
  end

  def method_missing(name, *args, &block)
    raise NoMethodError, "undefined method `#{name}` is called." unless @data.cells.respond_to?(name)
    @data.cells.send(name, *args, &block)
  end

  def surround(cell)
    @data.cells.select { |key, val|
      ((cell.x - 1)..(cell.x + 1)).include?(val.x) &&\
        ((cell.y - 1)..(cell.y + 1)).include?(val.y) &&\
        val.index != Board.index(cell.x, cell.y)
    }
  end

  def line(x)
    @data.cells.select { |i, cell| cell.x == x }
  end

  def row(y)
    @data.cells.select { |i, cell| cell.y == y }
  end

  def save
    @data.write
  end

  def self.index(x, y)
    x.to_s + '_' + y.to_s
  end

  def self.instance(board_id)
    @@boards[board_id] || Board.new(board_id)
  end

  private

  def create
    cells = {}
    (1..8).each do |x|
      (1..8).each do |y|
        cells[Board.index(x, y)] = Cell.new(x, y, @id)
      end
    end
    @data.cells = cells
  end
end
