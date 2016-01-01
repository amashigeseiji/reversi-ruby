class AI
  def initialize(game_id)
    @game_id = game_id
    @evaluator = Evaluator.new(game_id)
  end

  def choice
    return nil if game.moves.pass?
    return game.moves.first[0] if game.moves.length == 1
    @evaluator.evaluate(strategy)
  end

  def strategy
    game.cells.empties.length <= 10 ? 'min_max' : 'move'
  end

  private

  def game
    Game.instance(@game_id)
  end
end
