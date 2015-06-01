module Stones
  module Direction
    def east
      @east ||= -> (x, y) { [x+1, y] }
    end

    def west
      @west ||= -> (x, y) { [x-1, y] }
    end

    def north
      @north ||= -> (x, y) { [x, y+1] }
    end

    def south
      @south ||= -> (x, y) { [x, y-1] }
    end

    def all
      [east, west, south, north]
    end

    module_function :north, :south, :east, :west, :all
  end
end
