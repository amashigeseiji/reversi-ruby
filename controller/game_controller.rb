class GameController
  def initialize(request)
    @request = request
    set_board
  end

  def index
  end

  def move
    cell = @board.cells.cell(@request[:x], @request[:y])
    raise BadRequestError.new('指定されたセルが存在しません') unless cell
    raise BadRequestError.new('すでに石が置かれています') if cell.filled?
    raise BadRequestError.new('指定されたセルに石を置けません') unless @board.moves[cell.index]
    @board.moves[cell.index].execute
  end

  def reset
    @board.reset
  end

  def pass
    raise BadRequestError.new('指すことができるのでパスできません') unless @board.moves.empty?
    @board.next_turn
  end

  def ai
    @ai ||= AI.new(@board.id)
    cell = @board.cells[@ai.choice]
    return send :pass if cell.nil?
    @request[:x] = cell.x
    @request[:y] = cell.y
    send :move
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
end
