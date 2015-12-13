class Move
  attr_reader :board
  def initialize(board, turn)
    @board = board
    @turn = turn.to_sym
  end

  def movable
  end

  def execute(move)
    @cell = move
    raise_if move.filled?, '既に石が置かれています'
    cells = reversible_cells

    raise_if cells.empty?, 'どこも裏返せません'

    move.set(@turn)
    cells.each do |cell|
      cell.reverse
    end
    board.data.turn = opposite
  end

  private

  def reversible_cells
    cells = []

    return cells if next_cells.empty?

    next_cells.each do |next_cell|
      reversible_line(@cell, @cell.vector_to(next_cell)).each do |cell|
        cells << cell
      end
    end
    cells
  end

  def next_cells
    cells = []
    Cell.vectors.each do |vector|
      next_cell = @cell.next_cell(vector)
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
