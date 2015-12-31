class Moves < Hash
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

  private

  def game
    Game.instance(@game_id)
  end
end
