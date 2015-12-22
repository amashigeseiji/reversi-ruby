class Simulator
  def initialize(board_id)
    @orig_board_id = board_id
    @clone_id = 'sandbox/' + board_id.to_s
  end

  def create_sandbox(&block)
    Dir::mkdir './data/sandbox/' unless Dir::exist? './data/sandbox'
    resource = Resource.new(@clone_id)
    resource.cells = nil
    resource.turn = orig.turn
    resource.write

    board = Board.new(@clone_id)
    board.cells = Cells.new(@clone_id)
    board.cells.each do |index, cell|
     cell.instance_variable_set(:@color, orig.cells[index].color)
    end
    board.instance_variable_set(:@move, Move.new(@clone_id, board.turn))

    yield board
  end

  def destroy
    Board.delete(@clone_id)
  end

  # sandbox 環境内で与えられたブロックを評価する
  def self.simulate(board_id, &block)
    simulator = Simulator.new(board_id)
    begin
      simulator.create_sandbox do |board|
        yield board
      end
    rescue StandardError => e
      raise SimulatorError.new('Simulator Error: ' + e.message)
    ensure
      simulator.destroy
    end
  end

  private

  def orig
    Board.instance(@orig_board_id)
  end
end
