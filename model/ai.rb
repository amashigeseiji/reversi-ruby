class AI
  def initialize(board_id)
    @board_id = board_id
    @evaluator = Evaluator.new(board_id)
    @strategy = 'move'
  end

  def choice
    return nil if board.moves.empty?
    return board.moves.first[0] if board.moves.length == 1
    @evaluator.evaluate(@strategy)
  end

  private

  def board
    Board.instance(@board_id)
  end
end
