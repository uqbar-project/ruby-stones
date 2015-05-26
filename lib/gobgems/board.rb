module Gobgems
  class Board
    attr_reader :cells, :head_position

    def initialize(cells, position)
      @cells = cells
      @head_position = position
    end

    def push(color)
      head_cell[color] += 1
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

    def can_move?(direction)
      new_head_position = direction.call(*@head_position)
      (x, y) = size

      new_head_position[0] >= 0 && new_head_position[1] >= 0 &&
          new_head_position[0] <= x && new_head_position[1] <= y
    end

    def move(direction)
      raise 'Out of bouds' unless can_move? direction
      @head_position = direction.call(*@head_position)
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

    private

    def head_cell
      cell_at(head_position)
    end

    def cell_at(position)
      cells[position[0]][position[1]]
    end


    def self.empty_cell
      {red: 0, black: 0, green: 0, blue: 0}
    end
  end
end
