require './loader.rb'

class ReversiApp
  def call(env)
    request = Rack::Request.new(env)
    controller = Controller.new(request)
    response = Rack::Response.new do |res|
      res.status = 200
      res['Content-Type'] = 'text/html'
      res.write controller.render
    end
    response.finish
  end
end

use Rack::Reloader, 0
run ReversiApp.new
