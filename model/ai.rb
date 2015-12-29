class AI
  def initialize(board_id)
    @board_id = board_id
  end

  def choice
    return nil if board.moves.empty?
    return board.moves.first[0] if board.moves.length == 1
    Evaluator.new(@board_id).evaluate
  end

  private

  def board
    Board.instance(@board_id)
  end
end
