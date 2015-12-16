class Board
  @@boards = {}
  attr_reader :id

  def initialize(id = nil)
    @data = Resource.find(id)
    @id = @data.id
    add_accessors [:cells, :turn]
    setup unless @data.exist?
    @@boards[@id] = self
  end

  def setup
    @data[:cells] = Cells.new(@id)
    @data[:cells].setup
    @data[:turn] = :black
    save
  end

  def save
    @data.write
  end

  def next_turn
    @data[:turn] = @data[:turn] == :black ? :white : :black
    save
  end

  def self.instance(board_id)
    @@boards[board_id] ||= Board.new(board_id)
  end

  private

  def add_accessors(attr)
    attr.each do |key|
      self.class.class_eval do
        define_method "#{key}" do
          @data[key]
        end

        define_method "#{key}=" do |value|
          @data[key] = value
        end
      end
    end
  end
end
