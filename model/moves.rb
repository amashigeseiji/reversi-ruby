class Moves < Hash
  def initialize(board_id, turn)
    @board_id = board_id
    @turn = turn.to_sym
    setup
  end

  def opponent
    Moves.new(@board_id, @turn == :white ? :black : :white)
  end

  private

  def board
    Board.instance(@board_id)
  end

  def setup
    board.cells.empties.each do |index, cell|
      cells = reversible_cells(cell)
      self[cell.index] = Move.new(index, cells, @turn, @board_id) unless cells.empty?
    end
    self
  end

  def reversible_cells(cell)
    cells = []

    next_cells = next_cells cell
    return cells if next_cells.empty?

    next_cells.each do |next_cell|
      reversible_line(cell, cell.vector_to(next_cell)).each do |reversible|
        cells << reversible
      end
    end
    cells
  end

  def next_cells(cell)
    cells = []
    Cell.vectors.each do |vector|
      next_cell = cell.next_cell(vector)
      cells << next_cell if next_cell && next_cell.opposite_to?(@turn)
    end
    cells
  end

  def reversible_line(cell, vector)
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
end
