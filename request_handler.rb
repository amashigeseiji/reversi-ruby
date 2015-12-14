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
      actions = @controller.class.instance_methods(false)
      raise BadRequestError.new('指定されたURLが間違っています') unless actions.include? @request.action.to_sym
      @controller.send @request.action
    rescue BadRequestError, ReversiError => e
      @controller.instance_variable_set(:@error, e.message)
    rescue StandardError => e
      raise e
    end
  end

  def render
    View.new(@controller).html
  end
end
