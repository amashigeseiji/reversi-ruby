module Strategy
  class MinMax < AbstractStrategy
    def choice(game)
      @search_level = 3
      min_max(game, @search_level, true)
    end

    def min_max(game, depth, flag)
      return @evaluator.score(game) if depth == 0 || game.ended?

      value = flag ? -99999 : 99999
      best_index = nil

      game.moves.each do |index, move|
        move.simulate do |next_game|
          # 次の盤面の評価点
          child_value = min_max(next_game, depth - 1, !flag)

          condition = flag ? (value < child_value) : (value > child_value)
          if condition
            value = child_value
            best_index = index
          end
        end
      end

      # ルートノードの場合はセルの位置を返す
      # (それ以外は再帰処理)
      return depth == @search_level ? best_index : value
    end

    def score(game)
      point = evaluate_cells(game.cells.white.map{|k,v|v})
      point += 500 if game.win? :white
      point
    end
  end
end
