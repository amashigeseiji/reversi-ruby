module Simulatable
  def execute(save = true)
    raise 'Execute method is not implemented.'
  end

  def undo(save = true)
    raise 'Execute method is not implemented.'
  end

  def simulate(&block)
    begin
      execute false
      yield game
    rescue StandardError => e
      raise SimulatorError.new('Simulator Error: ' + e.message)
    ensure
      undo false
    end
  end

  def game
    Game.instance(@game_id)
  end
end
