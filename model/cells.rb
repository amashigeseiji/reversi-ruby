class Cells < Hash
  def initialize(game_id)
    @game_id = game_id
    (1..8).each do |x|
      (1..8).each do |y|
        self[Cells.index(x, y)] = Cell.new(x, y, game_id)
      end
    end
  end

  def [](index)
    index = Cells.index(*index) if index.is_a? Array
    super(index)
  end

  def line(x)
    self.select { |i, cell| cell.x == x }
  end

  def row(y)
    self.select { |i, cell| cell.y == y }
  end

  def empties
    select {|key, cell| !cell.filled? }
  end

  def setup
    self[[4, 4]].set(:white)
    self[[5, 4]].set(:black)
    self[[5, 5]].set(:white)
    self[[4, 5]].set(:black)
  end

  def self.index(x, y)
    x.to_s + '_' + y.to_s
  end

  def self.after_load
    # Cell クラスで xxx? で定義されていて引数を持たないメソッドを、
    # Cells クラスの select 条件メソッドとして定義する
    # (cell.white? が定義されていれば、 cells.white としてハッシュを返す)
    Cell.instance_methods(false)
    .select {|m| Cell.instance_method(m).parameters.empty? && m =~ /(.*)\?$/ }
    .each do |method|
      name = method.to_s.gsub(/\?$/, '')
      self.class_eval do
        define_method "#{name}" do
          select {|index, cell| cell.send(method) }
        end
      end
    end
  end
end
