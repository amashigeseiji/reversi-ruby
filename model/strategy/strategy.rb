module Strategy
  class AbstractStrategy
    def evaluate(game)
      raise 'Abstract method `evaluate` not defined'
    end

    def point(cell)
      if cell.corner?
        50
      elsif cell.wall?
        5
      else
        corner_empty = cell.game.cells.select {|index, c| index =~ /1_1|1_8|8_1|8_8/ && !c.filled? }.map {|k, v|k}
        if (cell.index == '2_2' && corner_empty.include?('1_1')) ||
           (cell.index == '2_7' && corner_empty.include?('1_8')) ||
           (cell.index == '7_2' && corner_empty.include?('8_1')) ||
           (cell.index == '7_7' && corner_empty.include?('8_8'))
          -40
        else
          1
        end
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

  def factory(name)
    require "./model/strategy/#{name}.rb"
    const_get(name.camelize).new
  end

  module_function :factory
end
