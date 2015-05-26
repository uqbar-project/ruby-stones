module Gobstones

end

module Gobstones
  module Color
    def red
      :red
    end

    def blue
      :blue
    end

    def green
      :green
    end

    def black
      :black
    end

    def all
      [red, green, black, blue]
    end

    module_function :red, :blue, :green, :black, :all
  end
end


module Gobstones
  module Direction
    def east
      @east ||= -> (x, y) { [x, y+1] }
    end

    def west
      @west ||= -> (x, y) { [x, y-1] }
    end

    def north
      @north ||= -> (x, y) { [x-1, y] }
    end

    def south
      @south ||= -> (x, y) { [x+1, y] }
    end

    def all
      [east, west, south, north]
    end

    module_function :north, :south, :east, :west, :all

  end
end


class Gobstones::Board
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


module Gobgems
  class ExecutionContext
    attr_accessor :board

    def run(program_class)
      program = program_class.new
      program.board = board
      program.main
    end
  end

  module Program
    attr_accessor :board

    include Gobstones::Color
    include Gobstones::Direction

    def move(direction)
      board.move(direction)
    end

    def push(color)
      board.push(color)
    end

    def pop(color)
      board.pop(color)
    end

    def exist?(color)
      board.exists?(color)
    end

    def can_move?(direction)
      board.can_move?(direction)
    end

    def count(color)
      board.count(color)
    end
  end

end
