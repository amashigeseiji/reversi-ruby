module Strategy
  class MinMax < AbstractStrategy
    def evaluate(board)
      @search_level = 3
      min_max(board, @search_level)
    end

    def min_max(board, depth)
      return score(board) if depth == 0

      value = board.turn == :white ? -99999 : 99999
      best_index = nil

      board.moves.each do |index, move|
        move.simulate do |next_board|
          # 次の盤面の評価点
          child_value = min_max(next_board, depth - 1)

          condition = board.turn == :white ? (value < child_value) : (value > child_value)
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

    def score(board)
      point = evaluate_cells(board.cells.white.map{|k,v|v})
      point += 500 if board.win? :white
      point
    end
  end
end
