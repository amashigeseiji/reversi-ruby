class GameController
  attr_reader :board
  attr_accessor :error

  def initialize(request)
    @request = request
    set_board
    @turn = @board.data.turn ? @board.data.turn : :white
    @error = nil
  end

  def index
    @move = Move.new(@board.id, @turn)
  end

  def move
    @move = Move.new(@board.id, @turn)
    cell = @board.find(@request[:x], @request[:y])
    if cell && !cell.filled? && @move.execute(cell)
      next_turn
      @board.save
    end
  end

  def reset
    @board.setup.save
    send :index
  end

  def render
    View.new(@request, self).html
  end

  def moves
    @move.moves
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
