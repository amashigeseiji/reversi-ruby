class Controller
  Rack::Request.send :define_method, :action do
    path_info.split('/')[1]
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @board = Board.instance
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
    move = Move.new(@request[:x], @request[:y], @request[:color])
    move.execute
  end

  def reset
    @board.setup
  end
end

class BadRequestError < StandardError
  def status
    400
  end
end
