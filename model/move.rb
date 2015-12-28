class Move
  attr_reader :index

  def initialize(index, turn, board_id)
    if index.is_a? Array
      @x = index[0]
      @y = index[1]
      @index = @x.to_s + '_' + @y.to_s
    elsif index.is_a? String
      @index = index
      tmp = @index.split('_')
      @x = tmp[0]
      @y = tmp[1]
    end
    @turn = turn
    @board_id = board_id
  end

  def execute
    cell.set(@turn)
    reversibles.each do |cell|
      cell.reverse
    end
    board.next_turn
  end

  def simulate(&block)
    Simulator.simulate(@board_id) do |board|
      board.moves[index].execute
      yield board
    end
  end

  def cell
    board.cells.cell(@x, @y)
  end

  def executable?
    !reversibles.empty?
  end

  def reversibles
    return @reversibles if @reversibles
    @reversibles = []
    next_cells.each do |next_cell|
      reversible_line(cell.vector_to(next_cell)).each do |reversible|
        @reversibles << reversible
      end
    end
    @reversibles
  end

  private

  def next_cells
    return @next_cells if @next_cells
    @next_cells = []
    Cell.vectors.each do |vector|
      next_cell = cell.next_cell(vector)
      @next_cells << next_cell if next_cell && next_cell.opposite_to?(@turn)
    end
    @next_cells
  end

  def reversible_line(vector)
    next_cell = cell.next_cell(vector)
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

  def board
    Board.instance(@board_id)
  end
end
