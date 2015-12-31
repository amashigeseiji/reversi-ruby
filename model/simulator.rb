class Simulator
  def initialize(game_id)
    @orig_game_id = game_id
    @clone_id = 'sandbox/' + Resource.random
  end

  def create_sandbox(&block)
    Dir::mkdir './data/sandbox/' unless Dir::exist? './data/sandbox'
    resource = Resource.new(@clone_id)
    resource.cells = nil
    resource.turn = orig.turn
    resource.write

    game = Game.new(@clone_id)
    game.cells = Cells.new(@clone_id)
    game.cells.each do |index, cell|
     cell.instance_variable_set(:@color, orig.cells[index].color)
    end

    yield game
  end

  def destroy
    Game.delete(@clone_id)
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
