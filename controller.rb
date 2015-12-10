class Controller
  def initialize(request)
    @request = request
    @board = Board.instance
  end

  def render
    before_render
    View.new(@request, @board, @error).html
  end

  def action
    @request.path_info.split('/')[1]
  end

  private

  def before_render
    if action
      begin
        send action
      rescue ReversiError => e
        @error = e.message
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
