class App
  Rack::Request.send :define_method, :action do
    dev? ? path_split[2] : path_split[1]
  end

  Rack::Request.send :define_method, :path_split do
    @path_split ||= path_info.split('/')
  end

  Rack::Request.send :define_method, :dev? do
    path_split[1] == 'dev'
  end

  def call(env)
    env['PATH_INFO'].match(/(.*)\.css/) do
      return [
          200,
          {'Content-Type' => 'text/css'},
          [open("./view/css#{$1}.css", &:read)]
        ]
    end
    controller = Controller.new(env)
    controller.response.finish
  end
end
