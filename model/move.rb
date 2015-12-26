class Move
  attr_reader :index, :reversibles
  def initialize(index, reversibles, turn, board_id)
    if index.is_a? Array
      @x = index[0]
      @y = index[1]
      @index = @x.to_s + '_' + @y.to_s
    elsif index.is_a? String
      @index = index
      tmp = @index.split('_')
      @x = tmp[0]
      @y = tmp[1]
    end
    @turn = turn
    @reversibles = reversibles
    @board_id = board_id
  end

  def execute
    cell.set(@turn)
    reversibles.each do |cell|
      cell.reverse
    end
  end

  def cell
    board.cells.cell(@x, @y)
  end

  private

  def board
    Board.instance(@board_id)
  end
end
