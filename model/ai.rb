class AI
  def initialize(board_id)
    @board_id = board_id
  end

  # 相手の指し手の全体を評価して、
  # 相手の点数が一番低い手を選択する
  # 自分の手の良し悪し（枚数が何枚増えるか、角がとれるか）は
  # 現状で考慮していない
  def move
    moves = board.moves
    return nil if moves.empty?

    evaluated = {}
    moves.each do |index, reversibles|
      evaluated[index] = evaluate_opponent(index)
    end
    cell(evaluated.min_by { |_, item| item }.first)
  end

  def simulate(cell_index)
    simulator = Simulator.new(@board_id)
    simulator.move_exec cell_index
    simulator
  end

  def evaluate_opponent(cell_index)
    simulator = simulate(cell_index)
    evaluated = 0
    simulator.moves.each do |index, cells|
      evaluated += evaluate(simulator.cells[index], cells)
    end
    evaluated
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
