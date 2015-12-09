require './board.rb'
require './draw.rb'

class Reversi
  attr_reader :board

  def initialize
    @board = Board.instance
    @turn = :white
    @end = false
    @drawer = Drawer.new
  end

  # 指し手
  def move(x, y)
    move = @board.find(x, y)

    # すでに石が置かれている
    raise_if move.filled?

    cells = reversible_cells(move)

    # どこも裏返せないとエラー
    raise_if cells.empty?

    move.set(@turn)
    cells.each do |cell|
      cell.reverse
    end
    @turn = opposite(@turn)
  end

  def draw
    @drawer.draw
  end

  private

  def reversible_cells(move)
    cells = []

    next_cells = @board.surround(move).select do |index, cell|
      cell.send((opposite(@turn).to_s + '?'))
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
      if !next_cell || !next_cell.color
        #次のセルが存在しないまたは値がない場合は値をリセット
        cells = []
        break
      end

      if next_cell.color != @turn
        #指し手と色が違う場合は配列に入れる
        cells << next_cell
      else
        break
      end
    end
    cells
  end

  def opposite(color)
    color == :white ? :black : :white
  end

  def raise_if(condition, message = nil)
    raise message ? message : 'このセルには石を置けません' if condition
  end
end
