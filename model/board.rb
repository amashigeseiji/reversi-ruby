class Board
  @@boards = {}
  attr_reader :id, :move

  def initialize(id = nil)
    @data = Resource.find(id)
    @id = @data.id
    add_accessors [:cells, :turn]
    setup unless @data.exist?
    @@boards[@id] = self
    @move = Move.new(@id, @data[:turn])
  end

  def setup
    @data[:cells] = Cells.new(@id)
    @data[:cells].setup
    @data[:turn] = :black
    save
  end

  def reset
    setup
    @move = Move.new(@id, @data[:turn])
  end

  def move_exec(cell)
    if @move.execute(cell)
      next_turn
    end
  end

  def moves
    @move.moves
  end

  def next_turn
    @data[:turn] = @data[:turn] == :black ? :white : :black
    save
    @move = Move.new(@id, @data[:turn])
  end

  def self.instance(board_id)
    @@boards[board_id] ||= Board.new(board_id)
  end

  private

  def save
    @data.write
  end

  def add_accessors(attr)
    attr.each do |key|
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
