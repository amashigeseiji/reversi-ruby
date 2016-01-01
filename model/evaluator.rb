class Evaluator
  def score(game)
    point = evaluate_cells(game.cells.white.map{|k,v|v})
    point += 500 if game.win? :white
    point
  end

  def move_score(move)
    point = 0
    if move.is_a? Pass
      point -= 50
    else
      point += point(move.cell) if move.cell.corner?
      point += evaluate_cells(move.reversibles.map {|i| i }.push(move.cell))
    end
    point
  end

  def point(cell)
    if cell.corner?
      50
    elsif cell.wall?
      5
    else
      corner_empty = cell.game.cells.corner.select {|index, c| !c.filled? }
      corner_empty.each do |index, corner|
        delta_x = corner.x - cell.x
        delta_y = corner.y - cell.y
        if delta_x == 1 && delta_y == 1 ||
          delta_x == -1 && delta_y == -1 ||
          delta_x == -1 && delta_y == 1
          delta_x == 1 && delta_y == -1
          return -40
        end
      end
      1
    end
  end

  def evaluate_cells(cells)
    sum = 0
    cells.each do |cell|
      sum += point(cell)
    end
    sum
  end
end
