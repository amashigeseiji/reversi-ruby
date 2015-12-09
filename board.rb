require 'singleton'
require './cell.rb'

class Board
  include Singleton

  def initialize
    setup
  end

  def setup
    generate
    find(4, 4).set(:white)
    find(5, 4).set(:black)
    find(5, 5).set(:white)
    find(4, 5).set(:black)
  end

  def cells
    @collection ||= generate
  end

  def find(x, y)
    index = Board.index(x, y)
    @collection.key?(index) ? @collection[index] : nil
  end

  def method_missing(name, *args, &block)
    raise NoMethodError, "undefined method `#{name}` is called." unless @collection.respond_to?(name)
    @collection.send(name, *args, &block)
  end

  def surround(cell)
    @collection.select { |key, val|
      ((cell.x - 1)..(cell.x+1)).include?(val.x) &&\
        ((cell.y - 1)..(cell.y + 1)).include?(val.y) &&\
        val.index != Board.index(cell.x, cell.y)
    }
  end

  def line(x)
    @collection.select do |i, cell|
      cell.x == x
    end
  end

  def self.index(x, y)
    x.to_s + '_' + y.to_s
  end

  private

  def generate
    @collection = {}
    (1..8).each do |x|
      (1..8).each do |y|
        @collection[Board.index(x, y)] = Cell.new(x, y)
      end
    end
  end
end
