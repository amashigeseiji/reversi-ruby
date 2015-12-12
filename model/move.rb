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

  def board
    @board
  end

  def reversible_cells
    cells = []

    return cells if next_cells.empty?

    next_cells.each_value do |next_cell|
      reversible_line(@cell, @cell.vector_to(next_cell)).each do |cell|
        cells << cell
      end
    end
    cells
  end

  def next_cells
    @next_cells ||= surround.select do |index, cell|
      cell.send(opposite.to_s + '?')
    end
  end

  def surround
    board.cells.select { |key, val|
      ((@cell.x - 1)..(@cell.x + 1)).include?(val.x) &&\
        ((@cell.y - 1)..(@cell.y + 1)).include?(val.y) &&\
        val.index != Board.index(@cell.x, @cell.y)
    }
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
