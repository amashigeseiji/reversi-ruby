class Moves < Hash
  alias_method :pass?, :empty?

  def initialize(game_id, turn = nil)
    @game_id = game_id
    @turn = turn.nil? ? game.turn : turn
    game.cells.empties.each do |index, cell|
      move = Move.new(index, @turn, @game_id)
      self[index] = move if move.executable?
    end
  end

  def opponent
    @opponent ||= Moves.new(@game_id, @turn == :white ? :black : :white)
  end

  # パスのときもループを回して、
  # パスオブジェクトに対してブロックを実行
  def each
    if empty?
      yield :pass, pass
    else
      super
    end
  end

  def pass
    Pass.new(@game_id) if pass?
  end

  private

  def game
    Game.instance(@game_id)
  end
end
