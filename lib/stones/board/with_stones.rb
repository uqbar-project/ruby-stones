module Stones
  module WithStones
    def push!(color, amount=1)
      head_cell[color] += amount
    end

    def pop!(color)
      raise "#{color} Underflow" if head_cell[color] == 0
      head_cell[color] -= 1
    end

    def clear!
      @cells = self.class.empty_cells(*size)
    end

    def count(color)
      head_cell[color]
    end

    def exist?(color)
      count(color) > 0
    end
  end
end
