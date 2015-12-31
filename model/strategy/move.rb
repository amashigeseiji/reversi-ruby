module Strategy
  class Move < AbstractStrategy
    def evaluate(game)
       game.moves
         .map {|index, move| [index, evaluate_move(move)]}
         .to_h
         .max_by {|_, evaluated| evaluated}[0]
    end

    def evaluate_move(move)
      evaluated = 0

      # 自分の指し手でひっくり返せるセルの合計点を加算
      evaluated += score move

      move.simulate do |game|
        included = false
        corner = []

        # 対戦相手の指し手
        game.moves.each do |index, next_move|
          # 相手の指し手の合計点を減算（相手の指し手の合計点が低いほうがよい）
          evaluated -= score next_move
          # AIが指した手が対戦相手にとられるかどうか
          included = next_move.reversibles.map {|cell| cell.index}.include?(move.index) unless included
          # 次番のAIの指し手
          next_move.simulate do |next_game|
            # 次の自分の盤の指し手で角が取れるかどうか(すべて true なら確実に角が取れる手)
            corner << next_game.moves.keys.any? {|i| i.match(/(1_1|1_8|8_1|8_8)/)}
          end

        end

        # 自分が指す手が一手先で相手に取られなければポイント追加
        evaluated += included ? -10 : 10
        # 次番で角を取ることができる場合
        evaluated += 50 unless corner.include?(false)
      end

      evaluated
    end

    def score(move)
      point = 0
      point += point(move.cell) if move.cell.corner?
      point += evaluate_cells(move.reversibles.map {|i| i }.push(move.cell))
      point
    end
  end
end
