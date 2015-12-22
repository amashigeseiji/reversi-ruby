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

  def ended?
    return true if @move.empties.empty?
    opponent_move = Move.new(@id, opponent)
    @move.moves.empty? && opponent_move.moves.empty?
  end

  def next_turn
    @data[:turn] = opponent
    save
    @move = Move.new(@id, @data[:turn])
  end

  def self.instance(board_id)
    @@boards[board_id] ||= Board.new(board_id)
  end

  def self.delete(board_id)
    if @@boards.has_key? board_id
      @@boards.delete(board_id)
      Resource.delete(board_id)
    end
  end

  private

  def save
    @data.write
  end

  def opponent
    @data[:turn] == :black ? :white : :black
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
