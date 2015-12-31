class Simulator
  def initialize(game_id)
    @orig_game_id = game_id
    @clone_id = Resource.random
  end

  def create_sandbox(&block)
    game = Game.new(@clone_id, true)
    game.cells = Cells.new(@clone_id)
    game.cells.each do |index, cell|
      cell.instance_variable_set(:@color, orig.cells[index].color)
    end
    game.turn = orig.turn

    yield game
  end

  def destroy
    Game.destroy(@clone_id)
  end

  # sandbox 環境内で与えられたブロックを評価する
  def self.simulate(game_id, &block)
    simulator = Simulator.new(game_id)
    begin
      simulator.create_sandbox do |game|
        yield game
      end
    rescue StandardError => e
      raise SimulatorError.new('Simulator Error: ' + e.message)
    ensure
      simulator.destroy
    end
  end

  private

  def orig
    Game.instance(@orig_game_id)
  end
end
