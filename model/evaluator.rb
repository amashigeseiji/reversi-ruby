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
    elsif cell.next_corner?
      if ['A2', 'B1', 'B2'].include? cell.index
        corner = 'A1'
      elsif ['A7', 'B7', 'B8'].include? cell.index
        corner = 'A8'
      elsif ['G1', 'G2', 'H2'].include? cell.index
        corner = 'H1'
      else
        corner = 'H8'
      end
      return cell.game.cells[corner].filled? ? 1 : -40
    elsif cell.wall?
      5
    else
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
