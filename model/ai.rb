class AI
  def initialize(board_id)
    @board_id = board_id
  end

  def choice
    return nil if board.moves.empty?
    # ruby 2.1以上
    Evaluator.new(@board_id).evaluate
      .max_by { |index, item| item }[0]
  end

  private

  def board
    Board.instance(@board_id)
  end
end
