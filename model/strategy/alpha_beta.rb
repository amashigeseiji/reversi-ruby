module Strategy
  class AlphaBeta < AbstractStrategy
    def choice(game)
      @search_level = 3
      alpha_beta(game, @search_level, true, -Float::INFINITY, Float::INFINITY)
    end

    def alpha_beta(game, depth, flag, alpha, beta)
      return @evaluator.score(game) if depth == 0 || game.ended?

      value = 0
      best_index = nil

      game.moves.each do |index, move|
        move.simulate do |node|
          # 次の盤面の評価点
          value = alpha_beta(node, depth - 1, !flag, alpha, beta)

          if flag && value > alpha
            alpha = value
            best_index = index
            return alpha if alpha >= beta
          elsif !flag && value < beta
            beta = value
            best_index = index
            return beta if alpha >= beta
          end
        end
      end

      # ルートノードの場合はセルの位置を返す
      # (それ以外は再帰処理)
      return best_index if depth == @search_level
      return flag ? alpha : beta
    end
  end
end
