class Evaluator
  def initialize(game_id)
    @game_id = game_id
    @default = 'move'
  end

  def evaluate(strategy = nil)
    strategy(strategy).evaluate(Game.instance(@game_id))
  end

  def strategy(strategy = nil)
    strategy ||= @default
    if !@strategy || @strategy.class.to_s.underscore != strategy
      @strategy = Strategy.factory(strategy)
    end
    @strategy
  end
end
