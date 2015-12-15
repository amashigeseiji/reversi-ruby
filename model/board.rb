class Board
  @@boards = {}
  attr_reader :id

  def initialize(id = nil)
    @data = Resource.find(id)
    @id = @data.id
    setup unless @data.exist?
    add_methods
    @@boards[@id] = self
  end

  def setup
    create
    cell(4, 4).set(:white)
    cell(5, 4).set(:black)
    cell(5, 5).set(:white)
    cell(4, 5).set(:black)
    @data[:turn] = :black
  end

  def cell(x, y)
    index = Board.index(x, y)
    @data.cells.key?(index) ? @data.cells[index] : nil
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
    @@boards[board_id] ||= Board.new(board_id)
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

  def add_methods
    #cells, turn
    @data.data.keys.each do |key|
      self.class.class_eval do
        define_method "#{key}" do
          @data[key]
        end

        define_method "#{key}=" do |value|
          @data[key] = value
        end
      end
    end
  end
end
