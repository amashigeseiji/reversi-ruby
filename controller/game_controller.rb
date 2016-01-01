class GameController
  def initialize(request)
    @request = request
    set_game
  end

  def index
  end

  def move
    cell = @game.cells[[@request[:x], @request[:y]]]
    raise BadRequestError.new('指定されたセルが存在しません') unless cell
    raise BadRequestError.new('すでに石が置かれています') if cell.filled?
    raise BadRequestError.new('指定されたセルに石を置けません') unless @game.moves[cell.index]
    @game.moves[cell.index].execute
  end

  def reset
    @game.reset
  end

  def pass
    raise BadRequestError.new('指すことができるのでパスできません') unless @game.moves.pass?
    @game.moves.pass.execute
  end

  def ai
    @ai ||= AI.new(@game.id)
    cell = @game.cells[@ai.choice]
    return send :pass if cell.nil?
    @request[:x] = cell.x
    @request[:y] = cell.y
    send :move
  end

  private

  def set_game
    if session['game_id']
      @game = Game.instance(session['game_id'])
      if @game.id != session['game_id']
        session['game_id'] = @game.id
      end
    else
      @game = Game.new
      session['game_id'] = @game.id
    end
  end

  def session
    @request.session
  end
end
