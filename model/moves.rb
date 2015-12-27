class Moves < Hash
  def initialize(board_id, turn = nil)
    @board_id = board_id
    @turn = turn.nil? ? board.turn : turn
    board.cells.empties.each do |index, cell|
      move = Move.new(index, @turn, @board_id)
      self[index] = move if move.executable?
    end
  end

  def opponent
    Moves.new(@board_id, @turn == :white ? :black : :white)
  end

  private

  def board
    Board.instance(@board_id)
  end
end
