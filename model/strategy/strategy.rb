module Strategy
  class AbstractStrategy
    def evaluate(board)
      raise 'Abstract method `evaluate` not defined'
    end

    def point(cell)
      if cell.corner?
        50
      elsif cell.index.match(/(2_2|2_7|7_2|7_7)/)
        -40
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

  def factory(name)
    require "./model/strategy/#{name}.rb"
    const_get(name.camelize).new
  end

  module_function :factory
end
