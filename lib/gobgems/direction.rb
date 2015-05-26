module Gobgems
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
