require 'erb'

class View
  attr_reader :request

  def initialize(request, board, error)
    @request = request
    @board = board
    @error = error
    Cell.send :define_method, :draw do
      '<span class="disc ' + @color.send(:to_s) + '"></span>'
    end
  end

  def html
    erb = ERB.new(File.read('./view/index.html.erb'))
    erb.result(binding)
  end
end
