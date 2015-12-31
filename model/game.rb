class Game
  @@games = {}
  attr_reader :id

  def initialize(id = nil)
    @data = Resource.find(id)
    @id = @data.id
    add_accessors [:cells, :turn]
    setup unless @data.exist?
    @@games[@id] = self
  end

  def setup
    @data[:cells] = Cells.new(@id)
    @data[:cells].setup
    @data[:turn] = :black
    save
  end

  def reset
    setup
    @moves = Moves.new(@id)
  end

  def moves
    @moves ||= Moves.new(@id)
  end

  def ended?
    return true if @data.cells.empties.empty?
    moves.empty? && moves.opponent.empty?
  end

  def next_turn
    @data[:turn] = opponent
    save
    @moves = Moves.new(@id)
  end

  def win?(player)
    cells.send(player).length > cells.send(player == :white ? :black : :white).length if ended?
  end

  def self.instance(game_id)
    @@games[game_id] ||= Game.new(game_id)
  end

  def self.delete(game_id)
    if @@games.has_key? game_id
      @@games.delete(game_id)
      Resource.delete(game_id)
    end
  end

  private

  def save
    @data.write
  end

  def opponent
    @data[:turn] == :black ? :white : :black
  end

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
