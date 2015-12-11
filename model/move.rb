class Move
  def initialize(x, y, turn, board_id)
    @x = x
    @y = y
    @turn = turn.to_sym
    @board_id = board_id
  end

  def execute
    move = board.find(@x, @y)

    raise_if move.filled?, '既に石が置かれています'

    cells = reversible_cells(move)

    raise_if cells.empty?, 'どこも裏返せません'

    move.set(@turn)
    cells.each do |cell|
      cell.reverse
    end
  end

  private

  def board
    Board.instance(@board_id)
  end

  def reversible_cells(move)
    cells = []

    next_cells = board.surround(move).select do |index, cell|
      cell.send(opposite.to_s + '?')
    end

    return cells if next_cells.empty?

    next_cells.each_value do |next_cell|
      reversible_line(move, move.vector_to(next_cell)).each do |cell|
        cells << cell
      end
    end
    cells
  end

  def reversible_line(move, vector)
    next_cell = move.send(vector)
    cells = [next_cell]
    while true do
      #同じ方向の次のセルを取得
      next_cell = next_cell.send(vector)
      if !next_cell || !next_cell.filled?
        #次のセルが存在しないまたは値がない場合は値をリセット
        cells = []
        break
      end

      if next_cell.color != @turn
        #指し手と色が違う場合は配列に入れる
        cells << next_cell
        next
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
