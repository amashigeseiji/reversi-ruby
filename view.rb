require 'erb'

class View
  attr_reader :request

  def initialize(request, controller)
    @request = request
    @board = controller.instance_variable_get(:@board)
    @move = controller.instance_variable_get(:@move)
    @error = controller.instance_variable_get(:@error)
  end

  def html
    erb = ERB.new(File.read('./view/index.html.erb'))
    erb.result(binding)
  end
end
