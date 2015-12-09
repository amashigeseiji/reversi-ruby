require './board.rb'
require './cell.rb'

class Cell
  def draw
    return '  ' if @color.nil?
    white? ? '○' : '●'
  end
end

class Drawer
  def initialize
    @board = Board.instance
  end

  def draw
    system('clear')
    puts  '    1  2  3  4  5  6  7  8 (x)'
    bar = "  -------------------------\n"
    (1..8).each do |x|
      text = x.to_s + ' '
      line = @board.line(x)
      line.each do |k, cell|
        text << '|' + cell.draw
      end
      puts bar + text + "|\n"
    end
    puts bar
    puts '(y)'
  end
end
