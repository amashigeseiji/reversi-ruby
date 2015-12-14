class RequestHandler
  def initialize(env)
    @request = Rack::Request.new(env)
    @controller = GameController.new(@request)
  end

  def response
    Rack::Response.new do |response|
      execute
      response.status = @status
      response['Content-Type'] = 'text/html'
      response.write render
    end
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

  def render
    View.new(@controller).html
  end
end
