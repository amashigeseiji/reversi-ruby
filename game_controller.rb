class GameController
  def initialize(request)
    @request = request
    set_board
    @turn = @board.data.turn ? @board.data.turn : :white
    @move = Move.new(@board.id, @turn)
    @error = nil
  end

  def index
  end

  def move
    cell = @board.find(@request[:x], @request[:y])
    if cell && !cell.filled? && @move.execute(cell)
      next_turn
      @board.save
    end
  end

  def reset
    @board.setup.save
    @move = Move.new(@board.id, @turn)
  end

  def pass
    raise '指すことができるのでパスできません' unless @move.moves.empty?
    next_turn
    @board.save
  end

  def render
    View.new(self).html
  end

  private

  def set_board
    if session['board_id']
      @board = Board.instance(session['board_id'])
      if @board.id != session['board_id']
        session['board_id'] = @board.id
      end
    else
      @board = Board.new
      session['board_id'] = @board.id
    end
  end

  def session
    @request.session
  end

  def next_turn
    @turn = @turn == :white ? :black : :white
    @board.data.turn = @board.data.turn == :white ? :black : :white
    @move = Move.new(@board.id, @turn)
  end
end
