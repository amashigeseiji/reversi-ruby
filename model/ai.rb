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
    # 一手の評価点
    move_point = ->(index, cells) {
      point = 0
      cell = cell(index)
      point += point(cell) if cell.corner?
      point += evaluate_cells(cells.map {|i| i }.push(cell))
      point
    }

    # とりあえず初期値を100点としておく（特に理由はないが正の整数のほうが見やすいため）
    evaluated = 100

    # 自分の指し手でひっくり返せるセルの合計点を加算
    evaluated += move_point.call(move_index, reversibles)

    simulate(@board_id, move_index) do |board|
      included = false
      my_corner = []

      # 対戦相手の指し手
      board.moves.each do |index, cells|
        # 相手の指し手の合計点を減算（相手の指し手の合計点が低いほうがよい）
        evaluated -= move_point.call(index, cells)
        # AIが指した手が対戦相手にとられるかどうか
        included = cells.map {|cell| cell.index}.include?(move_index) unless included
        # 次番のAIの指し手
        simulate(board.id, index) do |next_board|
          # 次の自分の盤の指し手で角が取れるかどうか(すべて true なら確実に角が取れる手)
          my_corner << next_board.moves.keys.any? {|i| i.match(/(1_1|1_8|8_1|8_8)/)}
        end

      end

      # 自分が指す手が一手先で相手に取られなければポイント追加
      evaluated += included ? -10 : 10
      # 次番で角を取ることができる場合
      evaluated += 20 unless my_corner.include?(false)
    end

    evaluated
  end

  private

  def simulate(board_id, index, &block)
    Simulator.simulate(board_id) do |board|
      board.move_exec board.cells[index]
      yield board
    end
  end

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
      50
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
