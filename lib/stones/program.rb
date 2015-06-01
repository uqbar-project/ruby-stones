module Stones
  module Program
    attr_accessor :board

    include Stones::Color
    include Stones::Direction

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
