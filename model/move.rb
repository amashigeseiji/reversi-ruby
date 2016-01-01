class Move
  attr_reader :cell

  def initialize(index, turn, game_id)
    @turn = turn
    @game_id = game_id
    @cell = game.cells[index]
  end

  # @params [bool] save 状態を保存するかどうか
  def execute(save = true)
    @cell.set(@turn)
    reversibles.each do |cell|
      cell.reverse
    end
    game.next_turn save
  end

  # @params [bool] save 状態を保存するかどうか
  def undo(save = true)
    @cell.instance_variable_set(:@color, nil)
    reversibles.each do |cell|
      cell.reverse
    end
    game.next_turn save
  end

  def simulate(&block)
    begin
      execute false
      yield game
    rescue StandardError => e
      raise SimulatorError.new('Simulator Error: ' + e.message)
    ensure
      undo false
    end
  end

  def executable?
    !reversibles.empty?
  end

  def reversibles
    return @reversibles if @reversibles
    @reversibles = []
    next_cells.each do |next_cell|
      reversible_line(@cell.vector_to(next_cell)).each do |reversible|
        @reversibles << reversible
      end
    end
    @reversibles
  end

  def index
    @cell.index
  end

  private

  def next_cells
    return @next_cells if @next_cells
    @next_cells = []
    Cell.vectors.each do |vector|
      next_cell = @cell.next_cell(vector)
      @next_cells << next_cell if next_cell && next_cell.opposite_to?(@turn)
    end
    @next_cells
  end

  def reversible_line(vector)
    next_cell = @cell.next_cell(vector)
    cells = [next_cell]
    while true do
      #同じ方向の次のセルを取得
      next_cell = next_cell.next_cell(vector)
      if !next_cell || !next_cell.filled?
        #次のセルが存在しないまたは値がない場合は値をリセット
        cells = []
        break
      end

      if next_cell.opposite_to?(@turn)
        #指し手と色が違う場合は配列に入れる
        cells << next_cell
      else
        break
      end
    end
    cells
  end

  def game
    Game.instance(@game_id)
  end
end
