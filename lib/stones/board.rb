module Stones
  class OutOfBoardError < RuntimeError
  end

  module WithMovementOps
    def can_move?(direction)
      within_bounds? next_position(direction)
    end

    def move!(direction)
      move_to! next_position(direction)
    end

    def move_to_edge!(direction)
      move!(direction) while can_move?(direction)
    end

    private

    def move_to!(position)
      raise OutOfBoardError unless within_bounds? position
      @head_position = position
    end

    def next_position(direction)
      direction.call(*@head_position)
    end

  end

  module WithColorOps
    def push!(color, amount=1)
      head_cell[color] += amount
    end

    def pop!(color)
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
      [cells[0].size, cells.size]
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
      self.new((1..y).map { (1..x).map { empty_cell } }, position)
    end

    def self.from(cells, position=[0, 0])
      self.new(cells.map { |row| row.map { |cell| empty_cell.merge(cell) } }, position)
    end

    private

    def each_cell
      (0..(size[0]-1)).each do |x|
        (0..(size[1]-1)).each do |y|
          yield cell_at([x, y]), x, y
        end
      end
    end

    def cell_at(position)
      raise OutOfBoardError unless within_bounds? position
      cells[-(position[1]+1)][position[0]]
    end

    def set_cell(position, cell)
      cell_at(position).merge! cell
    end

    def within_bounds?(position)
      (x, y) = size
      position[0] >= 0 && position[1] >= 0 &&
          position[0] < x && position[1] < y
    end

    def head_cell
      cell_at(head_position)
    end

    def self.empty_cell
      {red: 0, black: 0, green: 0, blue: 0}
    end
  end
end

