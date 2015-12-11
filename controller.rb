class Controller
  def initialize(env)
    @request = Rack::Request.new(env)
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

  def response
    @response ||= Rack::Response.new
    execute
    @response.status = @status
    @response['Content-Type'] = 'text/html'
    @response.write render
    @response
  end

  private

  def render
    View.new(@request, @board, @error).html
  end

  def execute
    @status = 200
    if @request.action
      begin
        send @request.action
      rescue ReversiError => e
        @error = e.message
      rescue BadRequestError => e
        @error = e.message
        @status = e.status
      end
    end
  end

  def move
    move = Move.new(@request[:x], @request[:y], @request[:color], @board.id)
    move.execute
    @board.save
  end

  def reset
    @board.setup.save
  end
end

class BadRequestError < StandardError
  def status
    400
  end
end
