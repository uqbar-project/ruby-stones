module Stones
  module WithHead
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
end
