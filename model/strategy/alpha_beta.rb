module Strategy
  class AlphaBeta < AbstractStrategy
    def evaluate(game)
      @search_level = 3
      alpha_beta(game, @search_level, -Float::INFINITY, Float::INFINITY)
    end

    def alpha_beta(game, depth, alpha, beta)
      return score(game) if depth == 0 || game.ended? || game.moves.empty?

      value = 0
      best_index = nil

      game.moves.each do |index, move|
        move.simulate do |next_game|
          # 次の盤面の評価点
          value = alpha_beta(next_game, depth - 1, alpha, beta)

          if game.turn == :white
            if value > alpha
              alpha = value
              best_index = index
              if (alpha >= beta)
                return alpha
              end
            end
          else
            if value < beta
              beta = value
              best_index = index
              if (alpha >= beta)
                return beta
              end
            end
          end
        end
      end

      # ルートノードの場合はセルの位置を返す
      # (それ以外は再帰処理)
      return best_index if depth == @search_level
      return game.turn == :white ? alpha : beta
    end

    def score(game)
      point = evaluate_cells(game.cells.white.map{|k,v|v})
      point += 500 if game.win? :white
      point
    end
  end
end
