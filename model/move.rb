class Move
  def initialize(board_id, turn)
    @board_id = board_id
    @turn = turn.to_sym
    @moves = {}
  end

  def moves
    # todo 手数がない場合について
    return @moves unless @moves.empty?
    empties.each do |index, cell|
      cells = reversible_cells(cell)
      @moves[cell.index] = cells unless cells.empty?
    end
    @moves
  end

  def execute(move)
    raise_if !moves.has_key?(move.index)
    move.set(@turn)
    moves[move.index].each do |cell|
      cell.reverse
    end
    @empties.delete(move.index)
  end

  private

  def board
    Board.instance(@board_id)
  end

  def empties
    @empties ||= board.cells.select {|key, cell| !cell.filled? }
  end

  def reversible_cells(move)
    cells = []

    next_cells = next_cells move
    return cells if next_cells.empty?

    next_cells.each do |next_cell|
      reversible_line(move, move.vector_to(next_cell)).each do |cell|
        cells << cell
      end
    end
    cells
  end

  def next_cells(move)
    cells = []
    Cell.vectors.each do |vector|
      next_cell = move.next_cell(vector)
      cells << next_cell if next_cell && next_cell.opposite_to?(@turn)
    end
    cells
  end

  def reversible_line(move, vector)
    next_cell = move.next_cell(vector)
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

  def opposite
    @turn == :white ? :black : :white
  end

  def raise_if(condition, message = nil)
    raise ReversiError.new(message ? message : 'このセルには石を置けません') if condition
  end
end

class ReversiError < StandardError
end
