class GameController
  def initialize(request)
    @request = request
    set_board
    @move = Move.new(@board.id, @board.turn)
  end

  def index
  end

  def move
    cell = @board.cell(@request[:x], @request[:y])
    raise BadRequestError.new('指定されたセルが存在しません') unless cell
    raise BadRequestError.new('すでに石が置かれています') if cell.filled?
    if @move.execute(cell)
      next_turn
    end
  end

  def reset
    @board.setup
    @board.save
    @move = Move.new(@board.id, @board.turn)
  end

  def pass
    raise BadRequestError.new('指すことができるのでパスできません') unless @move.moves.empty?
    next_turn
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
    @board.turn = @board.turn == :white ? :black : :white
    @board.save
    @move = Move.new(@board.id, @board.turn)
  end
end
