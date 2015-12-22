class AI
  def initialize(board_id)
    @board_id = board_id
  end

  def move
    return nil if board.moves.empty?
    # ruby 2.1以上
    cell board.moves
      .map {|index, reversibles| [index, evaluate(index, reversibles)]}
      .to_h
      .max_by { |_, item| item }[0]
  end

  # 指し手の評価
  def evaluate(move_index, reversibles)
    # とりあえず初期値を100点としておく（特に理由はないが正の整数のほうが見やすいため）
    evaluated = 100

    # 自分の指し手でひっくり返せるセルの合計点を加算
    evaluated += evaluate_cells(reversibles.map {|item|item}.push(cell(move_index)))

    Simulator.simulate(@board_id) do |board|
      included = false
      # シミュレーターの中で与えられた一手を実行する
      board.move_exec board.cells[move_index]

      board.moves.each do |index, cells|
        # 相手の指し手の合計点を減算（相手の指し手の合計点が低いほうがよい）
        evaluated -= evaluate_cells(cells.push(board.cells[index]))
        # 相手に角をとられる場合は減点
        evaluated -= 20 if board.cells[index].corner?
        included = cells.map {|cell| cell.index}.include?(move_index) unless included
      end

      # 自分が指す手が一手先で相手に取られなければポイント追加
      evaluated += included ? -10 : 10
    end

    evaluated
  end

  private

  def cell(index)
    tmp = index.split('_')
    board.cells.cell(tmp[0], tmp[1])
  end

  def evaluate_cells(cells)
    sum = 0
    cells.each do |cell|
      sum += point(cell)
    end
    sum
  end

  def point(cell)
    if cell.corner?
      20
    elsif cell.wall?
      5
    else
      1
    end
  end

  def board
    Board.instance(@board_id)
  end
end
