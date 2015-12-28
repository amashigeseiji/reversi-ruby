class AI
  def initialize(board_id)
    @board_id = board_id
  end

  def choice
    return nil if board.moves.empty?
    # ruby 2.1以上
    board.moves
      .map {|index, move| [index, Evaluator.new(move).evaluate]}
      .to_h
      .max_by { |_, item| item }[0]
  end

  private

  def board
    Board.instance(@board_id)
  end
end
