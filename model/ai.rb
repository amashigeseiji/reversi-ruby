class AI
  def initialize(board_id)
    @board_id = board_id
  end

  def move
    moves = board.moves
    return nil if moves.empty?

    evaluated = {}
    moves.each do |index, reversibles|
      evaluated[index] = evaluate(cell(index), reversibles)
    end
    cell(evaluated.max_by { |_, item| item }[0])
  end

  private

  def cell(index)
    tmp = index.split('_')
    board.cells.cell(tmp[0], tmp[1])
  end

  def evaluate(selected, reversibles)
    sum = 0
    reversibles.each do |cell|
      sum += point(cell)
    end
    sum += point(selected)
    sum
  end

  def point(cell)
    if cell.corner?
      8
    elsif cell.wall?
      3
    else
      1
    end
  end

  def board
    Board.instance(@board_id)
  end
end
