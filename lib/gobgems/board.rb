module Gobgems
  class OutOfBoardError < RuntimeError
  end

  module WithMovementOps
    def can_move?(direction)
      within_bounds? next_position(direction)
    end

    def move(direction)
      __move_to__ next_position(direction)
    end

    def __move_to__(position)
      raise OutOfBoardError unless within_bounds? position
      @head_position = position
    end

    private

    def next_position(direction)
      direction.call(*@head_position)
    end

  end

  module WithColorOps
    def push(color, amount=1)
      head_cell[color] += amount
    end

    def pop(color)
      raise "#{color} Underflow" if head_cell[color] == 0
      head_cell[color] -= 1
    end

    def count(color)
      head_cell[color]
    end

    def exist?(color)
      count(color) > 0
    end
  end

  class Board
    include WithMovementOps
    include WithColorOps

    attr_reader :cells, :head_position

    def initialize(cells, position)
      @cells = cells
      @head_position = position
    end

    def size
      [cells.size, cells[0].size]
    end

    def ==(other)
      self.class == other.class &&
          self.cells == other.cells &&
          self.head_position == other.head_position
    end

    def hash
      self.cells.hash ^ self.head_position.hash
    end

    def self.empty(x, y, position=[0, 0])
      self.new((1..x).map { (1..y).map { empty_cell } }, position)
    end

    def self.from(cells, position=[0, 0])
      self.new(cells.map { |row| row.map { |cell| empty_cell.merge(cell) } }, position)
    end

    def __set_cell__(position, cell)
      __cell_at__(position).merge! cell
    end

    def __cell_at__(position)
      raise OutOfBoardError unless within_bounds? position
      cells[position[0]][position[1]]
    end

    private

    def within_bounds?(position)
      (x, y) = size
      position[0] >= 0 && position[1] >= 0 &&
          position[0] <= x && position[1] <= y
    end

    def head_cell
      __cell_at__(head_position)
    end

    def self.empty_cell
      {red: 0, black: 0, green: 0, blue: 0}
    end
  end
end

