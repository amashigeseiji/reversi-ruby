class Controller
  def initialize(env)
    @request = Rack::Request.new(env)
    @controller = GameController.new(@request)
  end

  def response
    @response ||= Rack::Response.new
    execute
    @response.status = @status
    @response['Content-Type'] = 'text/html'
    @response.write @controller.render
    @response
  end

  private

  def execute
    @status = 200
    begin
      @controller.send @request.action ? @request.action : 'index'
    rescue ReversiError => e
      @controller.error = e.message
    end
  end
end
