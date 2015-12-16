require 'erb'
require 'json'

class View
  def initialize(controller)
    controller.instance_variables.each do |variable|
      eval "#{variable.to_s} = controller.instance_variable_get(variable)"
    end
  end

  def render
    send @request.xhr? ? :json : :html
  end

  def html
    erb = ERB.new(open('./view/index.html.erb', &:read))
    erb.result(binding)
  end

  def json
    erb = ERB.new(open("./view/#{@request.action}.json.erb", &:read))
    erb.result(binding)
  end
end
