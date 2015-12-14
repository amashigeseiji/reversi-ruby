class App
  Rack::Request.send :define_method, :action do
    action = dev? ? path_split[2] : path_split[1]
    action.nil? ? 'index' : action
  end

  Rack::Request.send :define_method, :path_split do
    @path_split ||= path_info.split('/')
  end

  Rack::Request.send :define_method, :dev? do
    path_split[1] == 'dev'
  end

  def call(env)
    handler = RequestHandler.new(env)
    handler.response.finish
  end
end
