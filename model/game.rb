class Game < Entity
  data_column :cells, :turn

  def after_initialize
    setup unless @data.exist?
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

  private

  def opponent
    @data[:turn] == :black ? :white : :black
  end
end
