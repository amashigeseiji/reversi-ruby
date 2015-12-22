class Simulator
  def initialize(board_id)
    @orig_board_id = board_id
    @clone_id = 'sandbox_' + board_id.to_s
  end

  def orig
    Board.instance(@orig_board_id)
  end

  def board
    @board ||= setup
  end

  def setup
    resource = Resource.new(@clone_id)
    resource.cells = nil
    resource.turn = orig.turn
    resource.write

    @board = Board.new(@clone_id)
    @board.cells = Cells.new(@clone_id)

    @board.cells.each do |index, cell|
      cell.instance_variable_set(:@color, orig.cells[index].color)
    end
    @board.instance_variable_set(:@move, Move.new(@clone_id, @board.turn))
    @board
  end

  def move_exec(index)
    board.move_exec board.cells[index]
  end

  def method_missing(name, *args)
    @board.send(name) if @board.respond_to?(name)
  end
end
