class Pass
  include Simulatable
  def initialize(game_id)
    @game_id = game_id
  end

  def execute(save = true)
    game.next_turn save
  end

  def undo(save = true)
    game.next_turn save
  end
end
