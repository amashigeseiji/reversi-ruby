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
      @controller.send @request.action
    rescue StandardError => e
      @controller.instance_variable_set(:@error, e.message)
    end
  end
end
