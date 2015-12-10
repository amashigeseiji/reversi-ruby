class App
  def call(env)
    controller = Controller.new(env)
    controller.response.finish
  end
end
