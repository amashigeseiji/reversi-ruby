class AI
  def initialize(game_id)
    @game_id = game_id
  end

  def choice
    return nil if game.moves.pass?
    return game.moves.first[0] if game.moves.length == 1
    strategy.choice(game)
  end

  def strategy(strategy = 'alpha_beta')
    #strategy = game.cells.empties.length <= 20 ? 'alpha_beta' : 'move'
    if !@strategy || @strategy.class.to_s.underscore != strategy
      @strategy = Strategy.factory(strategy)
    end
    @strategy
  end

  private

  def game
    Game.instance(@game_id)
  end
end
