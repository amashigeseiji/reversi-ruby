require 'erb'
require 'json'

class View
  def initialize(controller)
    controller.instance_variables.each do |variable|
      eval "#{variable.to_s} = controller.instance_variable_get(variable)"
    end
  end

  def html
    erb = ERB.new(File.read('./view/index.html.erb'))
    erb.result(binding)
  end
end
